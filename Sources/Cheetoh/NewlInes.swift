//
//  NewLInes.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/08.
//

import Foundation
import SwiftSyntax

public struct Newlines: SyntaxBuildable {
    public var syntax: SyntaxValues = SyntaxValues()
    
    private let count: Int
    
    public init(_ count: Int = 1) {
        self.count = count
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Newlines {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> TokenSyntax {
        SyntaxFactory.makeUnknown("", leadingTrivia: .newlines(count), trailingTrivia: .zero)
    }
}

extension Newlines: DeclMemberProtocol {
    public func buildDeclMember(format: Format) -> DeclSyntax {
        DeclSyntax(FunctionDeclSyntax {
            $0.useIdentifier(build(format: format))
        })
    }
}

extension Newlines: CodeBlockItem {
    public func buildCodeBlockItem(format: Format) -> CodeBlockItemSyntax {
        SyntaxFactory.makeCodeBlockItem(item: Syntax(build(format: format)), semicolon: nil, errorTokens: nil)
    }
}

extension Newlines: SourceFileScopeDeclaration {
}
