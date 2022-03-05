//
//  Extension.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/02/28.
//

import Foundation
import SwiftSyntax

public struct Extension: SyntaxBuildable, InheritedTypeProtocol, AccessControllable, AttributesAttachable, GenericWhereProtocol {
    public private(set) var syntax: SyntaxValues = SyntaxValues()

    private let type: TypeIdentifier
    private let members: [DeclMemberProtocol]

    public init(_ type: TypeIdentifier, @DeclMemberListBuilder builder: () -> [DeclMemberProtocol]) {
        self.type = type
        self.members = builder()
    }

    public init(_ type: TypeIdentifier, @DeclMemberListBuilder body: () -> DeclMemberProtocol) {
        self.type = type
        self.members = [body()]
    }

    public init(_ type: TypeIdentifier) {
        self.type = type
        self.members = []
    }

    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value

        return me
    }

    public func build(format: Format) -> ExtensionDeclSyntax {
        ExtensionDeclSyntax {
            $0.addAttribute(Syntax(SyntaxFactory.makeUnknown("").withLeadingTrivia(.spaces(format.base))))
            if let accessLevel = buildAccessLevel() {
                $0.addAttribute(Syntax(accessLevel))
            }

            $0.useExtensionKeyword(SyntaxFactory.makeExtensionKeyword(
                leadingTrivia: .zero,
                trailingTrivia: .spaces(1)
            ))

            $0.useExtendedType(SyntaxFactory.makeTypeIdentifier(type.name))

            if let inheritedTypes = buildInheritedTypes(format: format) {
                $0.useInheritanceClause(inheritedTypes)
            }

            if let genericWhere = buildGenericWhere(format: format) {
                $0.useGenericWhereClause(genericWhere)
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

extension Extension: DeclMemberProtocol, EnumDeclMemberProtocol {
    public func buildDeclMember(format: Format) -> DeclSyntax {
        DeclSyntax(build(format: format))
    }
}

extension Extension: SourceFileScopeDeclaration {
}
