//
//  Comment.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/04/01.
//

import Foundation
import SwiftSyntax

public struct Comment: SyntaxBuildable {
    public var syntax: SyntaxValues = SyntaxValues()
    
    private let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Comment {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> TokenSyntax {
        return SyntaxFactory.makeUnknown(
            "//\(text.split(separator: "\n").joined(separator: "\n//"))" ,
            leadingTrivia: .spaces(format.base),
            trailingTrivia: .newlines(1)
        )
    }
}

extension Comment: CodeBlockItem {
    public func buildCodeBlockItem(format: Format) -> CodeBlockItemSyntax {
        SyntaxFactory.makeCodeBlockItem(item: build(format: format), semicolon: nil, errorTokens: nil)
    }
}

extension Comment: SourceFileScopeDeclaration {
    public func buildSourceFileSyntax(format: Format) -> Syntax {
        build(format: format)
    }
}
