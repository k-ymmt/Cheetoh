//
//  Call.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/03/30.
//

import Foundation
import SwiftSyntax

extension SyntaxValues {
    var call: (name: String, arguments: [(String?, Expression)]?)? {
        get {
            values[\Self.call] as? (name: String, arguments: [(String?, Expression)]?)
        }
        set {
            values[\Self.call] = newValue
        }
    }
}

public protocol Callable: Expression, SyntaxBuildable {
    func call(_ name: String, arguments: [(String?, Expression)]) -> SelfType
    func member(_ name: String) -> SelfType
}

extension Callable  {
    public func call(_ name: String, arguments: [(String?, Expression)] = []) -> SelfType {
        return environment(\.call, (name, arguments))
    }
    
    public func member(_ name: String) -> SelfType {
        return environment(\.call, (name, nil))
    }

    func buildCall(format: Format, base: ExprSyntax) -> ExprSyntax {
        guard let (name, arguments) = syntax.call else {
            fatalError("syntax.call is nil. please call `call(:,arguments:)` or `member(:)` from \(base)")
        }
        
        if let arguments = arguments {
            return makeFunctionCallExpression(
                base: base,
                name: name,
                arguments: arguments,
                format: format
            )
        } else {
            return makeMemberAccessExpression(
                base: base,
                name: name,
                format: format
            )
        }
    }
    
    private func makeFunctionCallExpression(
        base: ExprSyntax,
        name: String, arguments: [(String?, Expression)],
        format: Format
    ) -> ExprSyntax {
        FunctionCallExprSyntax {
            $0.useCalledExpression(makeMemberAccessExpression(
                base: base,
                name: name,
                format: format
            ))
            $0.useLeftParen(SyntaxFactory.makeLeftParenToken())
            
            let lastIndex = arguments.count - 1
            for (name, expression) in arguments[0..<lastIndex] {
                $0.addArgument(FunctionCallArgumentSyntax {
                    if let name = name {
                        $0.useLabel(SyntaxFactory.makeIdentifier(name))
                        $0.useColon(SyntaxFactory.makeColonToken(
                            leadingTrivia: .zero,
                            trailingTrivia: .spaces(1)
                        ))
                    }
                    $0.useExpression(expression.buildExpression(format: format))
                    $0.useTrailingComma(SyntaxFactory.makeCommaToken(
                        leadingTrivia: .zero,
                        trailingTrivia: .spaces(1)
                    ))
                })
            }

            let (name, expression) = arguments[lastIndex]
            $0.addArgument(FunctionCallArgumentSyntax {
                if let name = name {
                    $0.useLabel(SyntaxFactory.makeIdentifier(name))
                    $0.useColon(SyntaxFactory.makeColonToken(
                        leadingTrivia: .zero,
                        trailingTrivia: .spaces(1)
                    ))
                }
                $0.useExpression(expression.buildExpression(format: format))
            })
            $0.useRightParen(SyntaxFactory.makeRightParenToken())
        }
    }
    
    private func makeMemberAccessExpression(
        base: ExprSyntax,
        name: String,
        format: Format
    ) -> ExprSyntax {
        return MemberAccessExprSyntax {
            $0.useBase(base)
            $0.useDot(SyntaxFactory.makeUnknown("."))
            $0.useName(SyntaxFactory.makeIdentifier(name))
        }
    }
}
