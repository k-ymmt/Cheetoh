//
//  Parameters.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

public struct ParameterVariable: SyntaxBuildable {
    public var syntax: SyntaxValues = SyntaxValues()
    
    let name: String
    let type: TypeIdentifier
    let label: String?
    
    init(_ name: String, type: TypeIdentifier, label: String? = nil) {
        self.name = name
        self.type = type
        self.label = label
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        return me
    }
    
    public func build(format: Format) -> FunctionParameterSyntax {
        FunctionParameterSyntax {
            if let label = label {
                $0.useFirstName(SyntaxFactory.makeIdentifier(label))
            }
            $0.useSecondName(SyntaxFactory.makeIdentifier(name))
            $0.useColon(SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
            $0.useType(type.build(format: format))
        }
    }
}

extension SyntaxValues {
    var parameters: [ParameterVariable]? {
        get {
            return values[\Self.parameters] as? [ParameterVariable]
        }
        set {
            values[\Self.parameters] = newValue
        }
    }
}

public protocol Parameters: SyntaxBuildable {
    func parameters(_ parameters: ParameterVariable...) -> SelfType
}

extension Parameters {
    public func parameters(_ parameters: ParameterVariable...) -> SelfType {
        return environment(\.parameters, parameters)
    }
    
    func buildParameters(format: Format) -> ParameterClauseSyntax {
        ParameterClauseSyntax {
            $0.useLeftParen(SyntaxFactory.makeLeftParenToken())
            if let parameters = syntax.parameters {
                let lastIndex = parameters.count - 1
                for parameter in parameters[0..<lastIndex] {
                    var parameter = parameter.build(format: format)
                    parameter.trailingComma = SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1))
                    $0.addParameter(parameter)
                    
                }
                $0.addParameter(parameters[lastIndex].build(format: format))
            }
            $0.useRightParen(SyntaxFactory.makeRightParenToken())
        }
    }
}
