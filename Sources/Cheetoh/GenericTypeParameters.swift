//
//  GenericParameters.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

struct GenericTypeParameter: SyntaxBuildable {
    private(set) var syntax: SyntaxValues = SyntaxValues()
    
    private let name: String
    private let inheritedType: TypeIdentifier?
    
    init(name: String, inheritedType: TypeIdentifier? = nil) {
        self.name = name
        self.inheritedType = inheritedType
    }
    
    func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        return me
    }
    
    func build(format: Format) -> GenericParameterSyntax {
        GenericParameterSyntax {
            $0.useName(SyntaxFactory.makeIdentifier(name))
            if let inheritedType = inheritedType {
                $0.useColon(SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                $0.useInheritedType(inheritedType.build(format: format))
            }
        }
    }
}

extension SyntaxValues {
    var inheritedTypes: [TypeIdentifier]? {
        get {
            values[\Self.inheritedTypes] as? [TypeIdentifier]
        }
        set {
            values[\Self.inheritedTypes] = newValue
        }
    }
}

public protocol InheritedTypeProtocol: SyntaxBuildable {
    func inheritedTypes(_ types: TypeIdentifier...) -> SelfType
}

extension InheritedTypeProtocol {
    public func inheritedTypes(_ types: TypeIdentifier...) -> SelfType {
        return environment(\.inheritedTypes, types)
    }

    public func inheritedTypes<T>(_ types: T.Type...) -> SelfType {
        return environment(\.inheritedTypes, types.map { TypeIdentifier(String(describing: $0)) })
    }

    func buildInheritedTypes(format: Format) -> TypeInheritanceClauseSyntax? {
        guard let types = syntax.inheritedTypes, types.count > 0 else {
            return nil
        }
        
        
        return TypeInheritanceClauseSyntax {
            $0.useColon(SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
            let lastIndex = types.count - 1
            for type in types[0..<lastIndex] {
                $0.addInheritedType(SyntaxFactory.makeInheritedType(
                    typeName: type.build(format: format),
                    trailingComma: SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                )
            }
            $0.addInheritedType(SyntaxFactory.makeInheritedType(
                typeName: types[lastIndex].build(format: format),
                trailingComma: nil
            ))
        }
    }
}

extension SyntaxValues {
    var genericTypeParameters: [GenericTypeParameter]? {
        get {
            values[\Self.genericTypeParameters] as? [GenericTypeParameter]
        }
        set {
            values[\Self.genericTypeParameters] = newValue
        }
    }
}

protocol GenericTypeParameters: SyntaxBuildable {
    func genericTypeParameters(_ types: GenericTypeParameter...) -> SelfType
}

extension GenericTypeParameters {
    func genericTypeParameters(_ types: GenericTypeParameter...) -> SelfType {
        return environment(\.genericTypeParameters, types)
    }
    
    func buildGenericTypeParameters(format: Format) -> GenericParameterClauseSyntax? {
        guard let generics = syntax.genericTypeParameters, generics.count > 0 else {
            return nil
        }
        
        return GenericParameterClauseSyntax {
            $0.useLeftAngleBracket(SyntaxFactory.makeLeftAngleToken())
            let lastIndex = generics.count - 1
            for type in generics[0..<lastIndex] {
                var parameter = type.build(format: format)
                parameter.colon = SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1))
                $0.addGenericParameter(parameter)
                
            }
            let lastType = generics[lastIndex]
            $0.addGenericParameter(lastType.build(format: format))
            $0.useRightAngleBracket(SyntaxFactory.makeRightAngleToken())
        }
    }
}
