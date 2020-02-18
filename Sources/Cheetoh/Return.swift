//
//  Return.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/11.
//

import Foundation
import SwiftSyntax

public struct Return: SyntaxBuildable, CodeBlockItem {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    private let expression: Expression
    
    public init(_ expression: Expression) {
        self.expression = expression
    }

    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> ReturnStmtSyntax {
        ReturnStmtSyntax {
            $0.useReturnKeyword(SyntaxFactory.makeReturnKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
            $0.useExpression(expression.buildExpression(format: format))
        }
    }
    
    public func buildCodeBlockItem(format: Format) -> CodeBlockItemSyntax {
        SyntaxFactory.makeCodeBlockItem(item: build(format: format), semicolon: nil, errorTokens: nil)
    }
}
