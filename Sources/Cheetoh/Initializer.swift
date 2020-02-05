//
//  Initializer.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

extension SyntaxValues {
    var initializer: Expression? {
        get {
            values[\Self.initializer] as? Expression
        }
        set {
            values[\Self.initializer] = newValue
        }
    }
}

public protocol InitializerProtocol: SyntaxBuildable {
    func initializer(_ expression: Expression) -> SelfType
}

extension InitializerProtocol {
    public func initializer(_ expression: Expression) -> SelfType {
        return environment(\.initializer, expression)
    }
    
    func buildInitializer(format: Format) -> InitializerClauseSyntax? {
        guard let initializer = syntax.initializer else {
            return nil
        }
        return InitializerClauseSyntax {
            $0.useEqual(SyntaxFactory.makeEqualToken(leadingTrivia: .spaces(1), trailingTrivia: .spaces(1)))
            $0.useValue(initializer.buildExpression(format: format))
        }
    }
}
