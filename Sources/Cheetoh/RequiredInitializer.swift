//
//  RequiredInitializer.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/03/30.
//

import Foundation
import SwiftSyntax

extension SyntaxValues {
    var required: Bool? {
        get {
            values[\Self.required] as? Bool
        }
        set {
            values[\Self.required] = newValue
        }
    }
}

public protocol RequiredInitializerProtocol: SyntaxBuildable {
    func required() -> SelfType
}

extension RequiredInitializerProtocol {
    public func required() -> SelfType {
        return environment(\.required, true)
    }
    
    func buildRequired() -> TokenSyntax? {
        guard let required = syntax.required, required else {
            return nil
        }
        return SyntaxFactory.makeUnknown("required", trailingTrivia: .spaces(1))
    }
}
