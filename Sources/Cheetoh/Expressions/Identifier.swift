//
//  Identifier.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/10.
//

import Foundation
import SwiftSyntax

public struct Identifier: SyntaxBuildable, Expression {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    private let name: String
    
    public init(_ name: String) {
        self.name = name
    }

    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> ExprSyntax {
        let identifier = SyntaxFactory.makeIdentifierExpr(
            identifier: SyntaxFactory.makeIdentifier(name),
            declNameArguments: nil
        )
        if syntax.call != nil {
            return buildCall(format: format, base: ExprSyntax(identifier))
        } else {
            return ExprSyntax(identifier)
        }
    }
    
    public func buildExpression(format: Format) -> ExprSyntax {
        build(format: format)
    }
}

extension Identifier: Callable {
}

extension Identifier: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self.name = value
    }
}
