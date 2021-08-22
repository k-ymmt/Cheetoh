//
//  EnumCase.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2021/08/22.
//

import Foundation
import SwiftSyntax

public struct EnumCase: SyntaxBuildable {
    public private(set) var syntax: SyntaxValues = SyntaxValues()

    private let name: String
    private let rawValue: ((Format) -> ExprSyntax)?
    private let associatedValue: KeyValuePairs<String?, TypeIdentifier>?

    public init(_ name: String) {
        self.name = name
        self.rawValue = nil
        self.associatedValue = nil
    }

    fileprivate init<Literal: LiteralProtocol>(_ name: String, rawValue: Literal) {
        self.name = name
        self.rawValue = { format in
            rawValue.buildExpression(format: format)
        }

        self.associatedValue = nil
    }

    public init(_ name: String, associatedValue: KeyValuePairs<String?, TypeIdentifier>) {
        self.name = name
        self.rawValue = nil
        self.associatedValue = associatedValue
    }

    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var variable = self
        variable.syntax[keyPath: keyPath] = value

        return variable
    }

    public func build(format: Format) -> EnumCaseDeclSyntax {
        EnumCaseDeclSyntax {
            $0.addAttribute(Syntax(
                SyntaxFactory
                    .makeUnknown("")
                    .withLeadingTrivia(.spaces(format.base))
            ))

            $0.useCaseKeyword(SyntaxFactory.makeCaseKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
            $0.addElement(EnumCaseElementSyntax {
                let trailingTrivia: Trivia = rawValue == nil && associatedValue == nil ? .newlines(1) : .zero
                $0.useIdentifier(SyntaxFactory.makeIdentifier(name, leadingTrivia: .zero, trailingTrivia: trailingTrivia))

                if let rawValue = rawValue {
                    $0.useRawValue(InitializerClauseSyntax {
                        $0.useEqual(SyntaxFactory.makeEqualToken(leadingTrivia: .spaces(1), trailingTrivia: .spaces(1)))
                        $0.useValue(rawValue(format).withTrailingTrivia(.newlines(1)))
                    })
                }

                if let associatedValue = associatedValue {
                    $0.useAssociatedValue(ParameterClauseSyntax {
                        $0.useLeftParen(SyntaxFactory.makeLeftParenToken())
                        for (name, type) in associatedValue.dropLast() {
                            $0.addParameter(FunctionParameterSyntax {
                                if let name = name {
                                    $0.useSecondName(SyntaxFactory.makeIdentifier(name))
                                    $0.useColon(SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                                }

                                $0.useType(type.build(format: format))
                                $0.useTrailingComma(SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                            })
                        }

                        let (name, type) = associatedValue.last!
                        $0.addParameter(FunctionParameterSyntax {
                            if let name = name {
                                $0.useSecondName(SyntaxFactory.makeIdentifier(name))
                                $0.useColon(SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                            }

                            $0.useType(type.build(format: format))
                        })

                        $0.useRightParen(SyntaxFactory.makeRightParenToken(leadingTrivia: .zero, trailingTrivia: .newlines(1)))
                    })
                }
            })
        }
    }
}

extension EnumCase: EnumDeclMemberProtocol {
    public func buildDeclMember(format: Format) -> DeclSyntax {
        DeclSyntax(build(format: format))
    }
}

extension EnumCase {
    public init(_ name: String, intValue: IntLiteral) {
        self.init(name, rawValue: intValue)
    }

    public init(_ name: String, stringValue: StringLiteral) {
        self.init(name, rawValue: stringValue)
    }

    public init(_ name: String, floatValue: FloatLiteral) {
        self.init(name, rawValue: floatValue)
    }
}
