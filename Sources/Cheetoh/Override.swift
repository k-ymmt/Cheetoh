//
//  Override.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/04/11.
//

import Foundation
import SwiftSyntax

extension SyntaxValues {
    var override: Bool? {
        get {
            values[\Self.override] as? Bool
        }
        set {
            values[\Self.override] = newValue
        }
    }
}

public protocol OverrideProtocol: SyntaxBuildable {
    func override() -> SelfType
}

extension OverrideProtocol {
    public func override() -> SelfType {
        return environment(\.override, true)
    }
    
    public func buildOverride(format: Format) -> TokenSyntax? {
        guard let override = syntax.override, override else {
            return nil
        }
        
        return SyntaxFactory.makeUnknown("override", trailingTrivia: .spaces(1))
    }
}
