//
//  Struct.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

public struct Struct: SyntaxBuildable, GenericTypeParameters, InheritedTypeProtocol, AccessControllable {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    private let name: String
    private let members: [DeclMemberProtocol]
    
    public init(_ name: String, @DeclMemberListBuilder builder: () -> [DeclMemberProtocol]) {
        self.name = name
        self.members = builder()
    }
    
    public init(_ name: String, @DeclMemberListBuilder body: () -> DeclMemberProtocol) {
        self.name = name
        self.members = [body()]
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> StructDeclSyntax {
        StructDeclSyntax {
            $0.addAttribute(SyntaxFactory.makeUnknown("").withLeadingTrivia(.spaces(format.base)))
            if let accessLevel = buildAccessLevel() {
                $0.addAttribute(accessLevel)
            }

            $0.useStructKeyword(SyntaxFactory.makeStructKeyword(
                leadingTrivia: .zero,
                trailingTrivia: .spaces(1)
            ))
            
            $0.useIdentifier(SyntaxFactory.makeIdentifier(name))
            if let generics = buildGenericTypeParameters(format: format) {
                $0.useGenericParameterClause(generics)
            }
            if let inheritedTypes = buildInheritedTypes(format: format) {
                $0.useInheritanceClause(inheritedTypes)
            }

            $0.useMembers(MemberDeclBlockSyntax {
                $0.useLeftBrace(SyntaxFactory.makeLeftBraceToken(
                    leadingTrivia: .spaces(1),
                    trailingTrivia: .newlines(1)
                ))
                let members = self.members.map { $0.buildDeclMember(format: format.incrementIndent()) }
                for member in members {
                    $0.addMember(MemberDeclListItemSyntax {
                        $0.useDecl(member)
                    })
                }
                
                $0.useRightBrace(SyntaxFactory.makeRightBraceToken(
                    leadingTrivia: .zero,
                    trailingTrivia: .newlines(1)
                ))
            })
        }
    }
}
