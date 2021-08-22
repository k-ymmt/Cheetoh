//
//  TypeIdentifier.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/01/31.
//

import Foundation
import SwiftSyntax

public struct TypeIdentifier: SyntaxBuildable, GenericArgumentsProtocol, NillableType {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    let name: String
    
    public init(_ name: String) {
        self.name = name
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> TypeIdentifier {
        var identifier = self
        identifier.syntax[keyPath: keyPath] = value
        return identifier
    }
    
    public func build(format: Format) -> TypeSyntax {
        let type = SimpleTypeIdentifierSyntax {
            $0.useName(SyntaxFactory.makeIdentifier(name))

            if let generics = buildGenericArguments(format: format) {
                $0.useGenericArgumentClause(generics)
            }
        }
        
        return buildNillableType(type: TypeSyntax(type))
    }
}

extension TypeIdentifier: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self.init(value)
    }
}

public extension TypeIdentifier {
    static func type<T>(_ type: T.Type) -> Self {
        self.init(String(describing: type))
    }
}
