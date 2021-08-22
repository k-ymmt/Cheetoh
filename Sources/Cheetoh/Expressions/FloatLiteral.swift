//
//  DoubleLiteralExpression.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/07.
//

import Foundation
import SwiftSyntax

public struct FloatLiteral: LiteralProtocol {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    private let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public init(_ float: Float) {
        self.text = String(float)
    }

    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> FloatLiteralExprSyntax {
        SyntaxFactory.makeFloatLiteralExpr(floatingDigits: SyntaxFactory.makeIdentifier(text))
    }
    
    public func buildExpression(format: Format) -> ExprSyntax {
        ExprSyntax(build(format: format))
    }
}

extension Float: Expression {
    public func buildExpression(format: Format) -> ExprSyntax {
        ExprSyntax(FloatLiteral(self).build(format: format))
    }
}

extension Double: Expression {
    public func buildExpression(format: Format) -> ExprSyntax {
        ExprSyntax(FloatLiteral(Float(self)).build(format: format))
    }
}
