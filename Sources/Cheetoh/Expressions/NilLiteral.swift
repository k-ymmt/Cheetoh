//
//  NilLiteral.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/11.
//

import Foundation
import SwiftSyntax

public struct NilLiteral: SyntaxBuildable, Expression {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    public init() {
    }

    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> NilLiteralExprSyntax {
        SyntaxFactory.makeNilLiteralExpr(nilKeyword: SyntaxFactory.makeNilKeyword())
    }
    
    public func buildExpression(format: Format) -> ExprSyntax {
        ExprSyntax(build(format: format))
    }
}
