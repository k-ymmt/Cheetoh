//
//  SourceFile.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/08.
//

import Foundation
import SwiftSyntax

public struct SourceFile: SyntaxBuildable {
    public var syntax: SyntaxValues = SyntaxValues()
    
    private let list: [SourceFileScopeDeclaration]
    
    public init(@SourceFileScopeDeclarationListBuilder builder: () -> [SourceFileScopeDeclaration]) {
        self.list = builder()
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> SourceFile {
        var me = self
        me.syntax[keyPath: keyPath] = value

        return me
    }
    
    public func build(format: Format) -> SourceFileSyntax {
        SourceFileSyntax {
            for item in list {
                $0.addStatement(CodeBlockItemSyntax {
                    $0.useItem(item.buildSourceFileSyntax(format: format))
                }.withTrailingTrivia(.newlines(1)))
            }
            $0.useEOFToken(SyntaxFactory.makeUnknown("").withLeadingTrivia(.newlines(1)))
        }
    }
}
