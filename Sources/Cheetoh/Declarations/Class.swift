//
//  Class.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/11.
//

import Foundation
import SwiftSyntax

public struct Class: SyntaxBuildable, GenericTypeParameters, InheritedTypeProtocol, AccessControllable {
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
    
    public init(_ name: String, emptyBody: () -> Void) {
        self.name = name
        self.members = []
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> ClassDeclSyntax {
        ClassDeclSyntax {
            $0.addAttribute(SyntaxFactory.makeUnknown("").withLeadingTrivia(.spaces(format.base)))
            if let accessLevel = buildAccessLevel() {
                $0.addAttribute(accessLevel)
            }
            
            $0.useClassKeyword(SyntaxFactory.makeClassKeyword(
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
                
                let incrementedFormat = format.incrementIndent()
                let members = self.members.map { $0.buildDeclMember(format: incrementedFormat) }
                for member in members {
                    $0.addMember(MemberDeclListItemSyntax {
                        $0.useDecl(member)
                    })
                }
                
                $0.useRightBrace(SyntaxFactory.makeRightBraceToken(
                    leadingTrivia: .spaces(format.base),
                    trailingTrivia: .newlines(1)
                ))
            })
        }
    }
}

extension Class: DeclMemberProtocol {
    public func buildDeclMember(format: Format) -> DeclSyntax {
        build(format: format)
    }
}

extension Class: SourceFileScopeDeclaration {
}
