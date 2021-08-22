//
//  StringLiteralExpression.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/02.
//

import Foundation
import SwiftSyntax

public struct StringLiteral: LiteralProtocol {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    private let text: String
    
    public init(_ text: String) {
        self.text = text
    }

    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> StringLiteralExprSyntax {
        SyntaxFactory.makeStringLiteralExpr(text)
    }
    
    public func buildExpression(format: Format) -> ExprSyntax {
        ExprSyntax(build(format: format))
    }
}

extension String: Expression {
    public func buildExpression(format: Format) -> ExprSyntax {
        ExprSyntax(StringLiteral(self).build(format: format))
    }
}
