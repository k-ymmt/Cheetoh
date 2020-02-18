//
//  FunctionCallExpression.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/07.
//

import Foundation
import SwiftSyntax

public struct Call: SyntaxBuildable, Expression {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    private let identifier: String
    private let arguments: KeyValuePairs<String?, Expression>?
    
    public init(_ identifier: String, _ arguments: KeyValuePairs<String?, Expression>? = nil) {
        self.identifier = identifier
        self.arguments = arguments
    }

    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> FunctionCallExprSyntax {
        FunctionCallExprSyntax {
            $0.useCalledExpression(SyntaxFactory.makeIdentifierExpr(
                identifier: SyntaxFactory.makeIdentifier(identifier),
                declNameArguments: nil
            ))

            $0.useLeftParen(SyntaxFactory.makeLeftParenToken())

            if let arguments = arguments, !arguments.isEmpty {
                let lastIndex = arguments.count - 1
                for (name, expression) in arguments[0..<lastIndex] {
                    $0.addArgument(FunctionCallArgumentSyntax {
                        if let name = name {
                            $0.useLabel(SyntaxFactory.makeIdentifier(name))
                            $0.useColon(SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                        }

                        $0.useExpression(expression.buildExpression(format: format))
                        $0.useTrailingComma(SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                    })
                }
                let lastArgument = arguments[lastIndex]
                $0.addArgument(FunctionCallArgumentSyntax {
                    if let name = lastArgument.key {
                        $0.useLabel(SyntaxFactory.makeIdentifier(name))
                        $0.useColon(SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                    }

                    $0.useExpression(lastArgument.value.buildExpression(format: format))
                })
            }
            
            $0.useRightParen(SyntaxFactory.makeRightParenToken())
        }
    }
    
    public func buildExpression(format: Format) -> ExprSyntax {
        build(format: format)
    }
}
