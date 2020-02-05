//
//  AccessControllable.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/01/31.
//

import Foundation
import SwiftSyntax

public enum AccessLevel {
    case `public`
    case `internal`
    case `fileprivate`
    case `private`
    
    func keyword() -> TokenSyntax {
        switch self {
        case .public:
            return SyntaxFactory.makePublicKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1))
        case .internal:
            return SyntaxFactory.makeInternalKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1))
        case .fileprivate:
            return SyntaxFactory.makeFileprivateKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1))
        case .private:
            return SyntaxFactory.makePrivateKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1))
        }
    }
}

extension SyntaxValues {
    var accessLevel: AccessLevel? {
        get {
            values[\Self.accessLevel] as? AccessLevel
        }
        set {
            values[\Self.accessLevel] = newValue
        }
    }
}

public protocol AccessControllable: SyntaxBuildable {
    func accessLevel(_ level: AccessLevel) -> SelfType
}

extension AccessControllable {
    public func accessLevel(_ level: AccessLevel) -> SelfType {
        return environment(\.accessLevel, level)
    }
    
    func buildAccessLevel() -> TokenSyntax {
        if let accessLevel = syntax.accessLevel {
            return accessLevel.keyword()
        } else {
            return SyntaxFactory.makeUnknown("")
        }
    }
}
