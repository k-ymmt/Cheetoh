//
//  Expression.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

public protocol Expression: CodeBlockItem {
    func buildExpression(format: Format) -> ExprSyntax
}

extension Expression {
    public func buildCodeBlockItem(format: Format) -> CodeBlockItemSyntax {
        SyntaxFactory.makeCodeBlockItem(item: buildExpression(format: format), semicolon: nil, errorTokens: nil)
    }
}
