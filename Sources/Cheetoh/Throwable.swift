//
//  Throwable.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

public enum ThrowsType {
    case `throws`
    case `rethrow`
    
    var keyword: TokenSyntax {
        switch self {
        case .throws:
            return SyntaxFactory.makeThrowsKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1))
        case .rethrow:
            return SyntaxFactory.makeRethrowsKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1))
        }
    }
}

extension SyntaxValues {
    var throwable: ThrowsType? {
        get {
            values[\Self.throwable] as? ThrowsType
        }
        set {
            values[\Self.throwable] = newValue
        }
    }
}

public protocol Throwable: SyntaxBuildable {
    func throwable(_ type: ThrowsType) -> SelfType
}

extension Throwable {
    public func throwable(_ type: ThrowsType) -> SelfType {
        return environment(\.throwable, type)
    }
    
    func buildThrowable() -> TokenSyntax? {
        guard let throwable = syntax.throwable else {
            return nil
        }
        
        return throwable.keyword
    }
}
