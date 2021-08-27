//
//  Statically.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/04/11.
//

import Foundation
import SwiftSyntax

extension SyntaxValues {
    var `static`: StaticType? {
        get {
            values[\Self.static] as? StaticType
        }
        set {
            values[\Self.static] = newValue
        }
    }
}

public enum StaticType {
    case `class`
    case `static`
}

public protocol StaticallyProtocol: SyntaxBuildable {
    func `static`(type: StaticType) -> SelfType
}

extension StaticallyProtocol {
    public func `static`(type: StaticType = .static) -> SelfType {
        return environment(\.static, type)
    }
    
    public func buildStatic(format: Format) -> TokenSyntax? {
        guard let type = syntax.static else {
            return nil
        }
        
        switch type {
        case .class:
            return SyntaxFactory.makeClassKeyword(
                leadingTrivia: .zero,
                trailingTrivia: .spaces(1)
            )
        case .static:
            return SyntaxFactory.makeStaticKeyword(
                leadingTrivia: .zero,
                trailingTrivia: .spaces(1)
            )
        }
    }
}
