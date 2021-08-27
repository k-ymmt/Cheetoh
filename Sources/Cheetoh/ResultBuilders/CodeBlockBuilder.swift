//
//  CodeBlockBuilder.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2021/08/27.
//

import Foundation
import SwiftSyntax

public protocol CodeBlockItem {
    func buildCodeBlockItem(format: Format) -> CodeBlockItemSyntax
}

@resultBuilder
public struct CodeBlockBuilder {
    public static func buildBlock(_ items: [CodeBlockItem]...) -> [CodeBlockItem] {
        return Array(items.joined())
    }

    public static func buildOptional(_ items: [CodeBlockItem]?) -> [CodeBlockItem] {
        return items ?? []
    }

    public static func buildEither(first items: [CodeBlockItem]) -> [CodeBlockItem] {
        return items
    }

    public static func buildEither(second items: [CodeBlockItem]) -> [CodeBlockItem] {
        return items
    }

    public static func buildExpression(_ item: CodeBlockItem) -> [CodeBlockItem] {
        return [item]
    }

    public static func buildArray(_ items: [[CodeBlockItem]]) -> [CodeBlockItem] {
        return Array(items.joined())
    }
}

