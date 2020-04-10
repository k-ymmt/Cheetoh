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
    
    public init(_ name: String, type: TypeIdentifier, label: String? = nil) {
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

public extension ParameterVariable {
    init<Type>(_ name: String, type: Type.Type, label: String? = nil) {
        self.init(name, type: TypeIdentifier(String(describing: type)), label: label)
    }
}
