//
//  Expression.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

struct Substitution: SyntaxBuildable {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    let identifierName: String
    let expression: Expression
    
    public init(_ targetName: String, _ expression: Expression) {
        self.identifierName = targetName
        self.expression = expression
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    func build(format: Format) -> ExprListSyntax {
        SyntaxFactory.makeExprList([
            IdentifierExprSyntax {
                $0.useIdentifier(SyntaxFactory.makeIdentifier(identifierName))
            },
            BinaryOperatorExprSyntax {
                $0.useOperatorToken(SyntaxFactory.makeOperatorKeyword(leadingTrivia: .spaces(1), trailingTrivia: .spaces(1)))
            },
            expression.buildExpression(format: format)
        ])
    }
}

extension Substitution: CodeBlockItem {
    func buildCodeBlockItem(format: Format) -> CodeBlockItemSyntax {
        CodeBlockItemSyntax {
            $0.useItem(build(format: format))
        }
    }
}

public protocol Expression {
    func buildExpression(format: Format) -> ExprSyntax
}


