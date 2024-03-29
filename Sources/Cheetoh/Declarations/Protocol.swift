//
//  Protocol.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/03/29.
//

import Foundation
import SwiftSyntax

public struct Protocol: SyntaxBuildable, InheritedTypeProtocol, AccessControllable, AttributesAttachable {
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
    
    public init(_ name: String) {
        self.name = name
        self.members = []
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> ProtocolDeclSyntax {
        ProtocolDeclSyntax {
            $0.addAttribute(Syntax(SyntaxFactory.makeUnknown("").withLeadingTrivia(.spaces(format.base))))
            if let accessLevel = buildAccessLevel() {
                $0.addAttribute(Syntax(accessLevel))
            }
            
            $0.useProtocolKeyword(SyntaxFactory.makeProtocolKeyword(
                leadingTrivia: .zero,
                trailingTrivia: .spaces(1)
            ))
            
            $0.useIdentifier(SyntaxFactory.makeIdentifier(name))
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

extension Protocol: DeclMemberProtocol, EnumDeclMemberProtocol {
    public func buildDeclMember(format: Format) -> DeclSyntax {
        DeclSyntax(build(format: format))
    }
}

extension Protocol: SourceFileScopeDeclaration {
}
