//
//  File.swift
//  File
//
//  Created by Kazuki Yamamoto on 2021/08/22.
//

import Foundation
import SwiftSyntax

public struct Enum: SyntaxBuildable, GenericTypeParameters, InheritedTypeProtocol, AccessControllable, AttributesAttachable, GenericWhereProtocol {

    public private(set) var syntax: SyntaxValues = SyntaxValues()

    private let name: String
    private let members: [EnumDeclMemberProtocol]

    public init(_ name: String, @EnumDeclMemberListBuilder builder: () -> [EnumDeclMemberProtocol]) {
        self.name = name
        self.members = builder()
    }

    public init(_ name: String, @EnumDeclMemberListBuilder body: () -> EnumDeclMemberProtocol) {
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

    public func build(format: Format) -> EnumDeclSyntax {
        EnumDeclSyntax {
            $0.addAttribute(
                Syntax(SyntaxFactory
                        .makeUnknown("")
                        .withLeadingTrivia(.spaces(format.base))
                )
            )

            if let accessLevel = buildAccessLevel() {
                $0.addAttribute(Syntax(accessLevel))
            }

            $0.useEnumKeyword(SyntaxFactory.makeEnumKeyword(
                leadingTrivia: .zero,
                trailingTrivia: .spaces(1)
            ))

            $0.useIdentifier(SyntaxFactory.makeIdentifier(name))
            if let generics = buildGenericTypeParameters(format: format) {
                $0.useGenericParameters(generics)
            }
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

extension Enum: DeclMemberProtocol, EnumDeclMemberProtocol {
    public func buildDeclMember(format: Format) -> DeclSyntax {
        DeclSyntax(build(format: format))
    }
}

extension Enum: SourceFileScopeDeclaration {
}
