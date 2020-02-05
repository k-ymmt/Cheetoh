//
//  Nillable.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

extension SyntaxValues {
    var nillable: Bool {
        get {
            values[\Self.nillable] as? Bool ?? false
        }
        set {
            values[\Self.nillable] = newValue
        }
    }
}

public protocol NillableType: SyntaxBuildable {
    func nillable() -> SelfType
}

extension NillableType {
    public func nillable() -> SelfType {
        return environment(\.nillable, true)
    }
    
    func buildNillableType(type: TypeSyntax) -> TypeSyntax {
        guard syntax.nillable else {
            return type
        }
        
        return SyntaxFactory.makeOptionalType(wrappedType: type, questionMark: SyntaxFactory.makePostfixQuestionMarkToken())
    }
}
