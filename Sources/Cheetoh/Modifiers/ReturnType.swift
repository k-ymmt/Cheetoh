//
//  ReturnType.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

extension SyntaxValues {
    var returnType: TypeIdentifier? {
        get {
            values[\Self.returnType] as? TypeIdentifier
        }
        set {
            values[\Self.returnType] = newValue
        }
    }
}

public protocol ReturnType: SyntaxBuildable {
    func returnType(_ type: TypeIdentifier) -> SelfType
}

extension ReturnType {
    public func returnType(_ type: TypeIdentifier) -> SelfType {
        return environment(\.returnType, type)
    }

    public func returnType<T>(_ type: T.Type) -> SelfType {
        return environment(\.returnType, .type(type))
    }
    
    func buildReturnType(format: Format) -> ReturnClauseSyntax? {
        guard let type = syntax.returnType else {
            return nil
        }
        return ReturnClauseSyntax {
            $0.useArrow(SyntaxFactory.makeArrowToken(
                leadingTrivia: .spaces(1),
                trailingTrivia: .spaces(1)
            ))
            $0.useReturnType(type.build(format: format))
        }
    }
}
