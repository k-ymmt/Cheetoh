//
//  Assign.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/04/01.
//

import Foundation
import SwiftSyntax

public struct Assign: SyntaxBuildable {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    let left: Expression
    let right: Expression
    
    public init(_ left: Expression, _ right: Expression) {
        self.left = left
        self.right = right
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> SequenceExprSyntax {
        SyntaxFactory.makeSequenceExpr(elements: SyntaxFactory.makeExprList([
            left.buildExpression(format: format),
            ExprSyntax(SyntaxFactory.makeAssignmentExpr(assignToken: SyntaxFactory.makeUnknown(
                "=",
                leadingTrivia: .spaces(1),
                trailingTrivia: .spaces(1)
            ))),
            right.buildExpression(format: format)
        ]))
    }
}

extension Assign: CodeBlockItem {
    public func buildCodeBlockItem(format: Format) -> CodeBlockItemSyntax {
        CodeBlockItemSyntax {
            $0.useItem(Syntax(build(format: format)))
        }
    }
}

