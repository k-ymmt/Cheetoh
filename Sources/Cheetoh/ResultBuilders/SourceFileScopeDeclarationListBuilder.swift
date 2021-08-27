//
//  SourceFileScopeDeclarationListBuilder.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2021/08/27.
//

import Foundation
import SwiftSyntax

public protocol SourceFileScopeDeclaration {
    func buildSourceFileSyntax(format: Format) -> Syntax
}

@resultBuilder
public struct SourceFileScopeDeclarationListBuilder {
    public static func buildBlock(_ list: [SourceFileScopeDeclaration]...) -> [SourceFileScopeDeclaration] {
        return Array(list.joined())
    }

    public static func buildOptional(_ list: [SourceFileScopeDeclaration]?) -> [SourceFileScopeDeclaration] {
        return list ?? []
    }

    public static func buildEither(first list: [SourceFileScopeDeclaration]) -> [SourceFileScopeDeclaration] {
        return list
    }

    public static func buildEither(second list: [SourceFileScopeDeclaration]) -> [SourceFileScopeDeclaration] {
        return list
    }

    public static func buildExpression(_ item: SourceFileScopeDeclaration) -> [SourceFileScopeDeclaration] {
        return [item]
    }

    public static func buildArray(_ list: [[SourceFileScopeDeclaration]]) -> [SourceFileScopeDeclaration] {
        return Array(list.joined())
    }
}

extension SourceFileScopeDeclaration where Self: DeclMemberProtocol {
    public func buildSourceFileSyntax(format: Format) -> Syntax {
        Syntax(buildDeclMember(format: format))
    }
}
