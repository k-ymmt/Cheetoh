//
//  IntLiteralExpression.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/07.
//

import Foundation
import SwiftSyntax

public struct IntLiteral: LiteralProtocol {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    private let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public init(_ digits: Int) {
        self.text = String(digits)
    }

    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> IntegerLiteralExprSyntax {
        SyntaxFactory.makeIntegerLiteralExpr(digits: SyntaxFactory.makeIdentifier(String(text)))
    }
    
    public func buildExpression(format: Format) -> ExprSyntax {
        ExprSyntax(build(format: format))
    }
}

extension Int: Expression {
    public func buildExpression(format: Format) -> ExprSyntax {
        ExprSyntax(IntLiteral(self).build(format: format))
    }
}
