//
//  CustomAttribute.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/03/05.
//

import Foundation
import SwiftSyntax

public struct CustomAttribute: Attribute {
    private let type: TypeIdentifier
    private let arguments: [(String?, Expression)]?

    public init(_ type: TypeIdentifier) {
        self.type = type
        self.arguments = nil
    }

    public init(_ type: TypeIdentifier, arguments: [(String?, Expression)]) {
        self.type = type
        self.arguments = arguments
    }

    public init(_ type: TypeIdentifier, arguments: KeyValuePairs<String?, Expression>) {
        self.type = type
        self.arguments = arguments.map { ($0, $1) }
    }

    public func buildAttribute(format: Format) -> Syntax {
        Syntax(CustomAttributeSyntax {
            $0.useAtSignToken(SyntaxFactory.makeAtSignToken())
            $0.useAttributeName(type.build(format: format))

            if let arguments = arguments {
                $0.useLeftParen(SyntaxFactory.makeLeftParenToken())

                var iter = arguments.makeIterator()
                var next = iter.next()

                while let (label, expression) = next {
                    $0.addArgument(TupleExprElementSyntax {
                        if let label = label {
                            $0.useLabel(SyntaxFactory.makeIdentifier(label))
                            $0.useColon(SyntaxFactory.makeColonToken(
                                leadingTrivia: .zero,
                                trailingTrivia: .spaces(1)
                            ))
                        }

                        $0.useExpression(expression.buildExpression(format: format))

                        next = iter.next()
                        if next != nil {
                            $0.useTrailingComma(SyntaxFactory.makeCommaToken(
                                leadingTrivia: .zero,
                                trailingTrivia: .spaces(1)
                            ))
                        }
                    })
                }
            }
        }).withTrailingTrivia(.spaces(1))
    }
}

