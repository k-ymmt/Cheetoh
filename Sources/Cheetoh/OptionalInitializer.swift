//
//  OptionalInitializer.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/04/11.
//

import Foundation
import SwiftSyntax

extension SyntaxValues {
    var optional: Bool? {
        get {
            values[\Self.optional] as? Bool
        }
        set {
            values[\Self.optional] = newValue
        }
    }
}

public protocol OptionalInitializerProtocol: SyntaxBuildable {
    func optional() -> SelfType
}

extension OptionalInitializerProtocol {
    public func optional() -> SelfType {
        return environment(\.optional, true)
    }
    
    func buildOptional() -> TokenSyntax? {
        guard let optional = syntax.optional, optional else {
            return nil
        }
        
        return SyntaxFactory.makePostfixQuestionMarkToken()
    }
}
