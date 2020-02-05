//
//  Generics.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

public protocol GenericArgumentsProtocol: SyntaxBuildable {
    func genericArguments(_ types: TypeIdentifier...) -> SelfType
}

extension GenericArgumentsProtocol {
    public func genericArguments(_ types: TypeIdentifier...) -> SelfType {
        return environment(\.generics, types)
    }
    
    func buildGenericArguments(format: Format) -> GenericArgumentClauseSyntax? {
        guard let generics = syntax.generics, generics.count > 0 else {
            return nil
        }
        
        return GenericArgumentClauseSyntax {
            $0.useLeftAngleBracket(SyntaxFactory.makeLeftAngleToken())
            let lastIndex = generics.count - 1
            let lastType = generics[lastIndex]
            for type in generics[0..<lastIndex] {
                $0.addArgument(SyntaxFactory.makeGenericArgument(
                    argumentType: type.build(format: format),
                    trailingComma: SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                )
            }
            $0.addArgument(SyntaxFactory.makeGenericArgument(argumentType: lastType.build(format: format), trailingComma: nil))
            $0.useRightAngleBracket(SyntaxFactory.makeRightAngleToken())
        }
    }
}

extension SyntaxValues {
    var generics: [TypeIdentifier]? {
        get {
            values[\Self.generics] as? [TypeIdentifier]
        }
        set {
            values[\Self.generics] = newValue
        }
    }
}
