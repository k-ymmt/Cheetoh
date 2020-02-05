//
//  Variable.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

public protocol VariableMutability {
    static var keyword: TokenSyntax { get }
}

public struct LetMutability: VariableMutability {
    public static var keyword: TokenSyntax {
        return SyntaxFactory.makeLetKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1))
    }
}

public enum VarMutability: VariableMutability {
    public static var keyword: TokenSyntax {
        return SyntaxFactory.makeVarKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1))
    }
}

public typealias Let = Variable<LetMutability>
public typealias Var = Variable<VarMutability>

public struct Variable<Mutability: VariableMutability>: SyntaxBuildable, AccessControllable, InitializerProtocol {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    private let name: String
    private let type: TypeIdentifier
    
    public init(name: String, type: TypeIdentifier) {
        self.name = name
        self.type = type
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Variable<Mutability> {
        var variable = self
        variable.syntax[keyPath: keyPath] = value
        
        return variable
    }
    
    public func build(format: Format) -> VariableDeclSyntax {
        VariableDeclSyntax {
            var accessLevel = self.buildAccessLevel()
            accessLevel.leadingTrivia = .spaces(format.base)
            $0.addAttribute(accessLevel)
            $0.useLetOrVarKeyword(Mutability.keyword)
            
            let initializer = buildInitializer(format: format)

            var binding = SyntaxFactory.makePatternBinding(
                pattern: SyntaxFactory.makeIdentifierPattern(identifier: SyntaxFactory.makeIdentifier(name)),
                typeAnnotation: SyntaxFactory.makeTypeAnnotation(
                    colon: SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)),
                    type: type.build(format: format)
                ),
                initializer: initializer, accessor: nil, trailingComma: nil
            )
            binding.trailingTrivia = .newlines(1)
            $0.addBinding(binding)
        }
    }
}

extension Variable: DeclMemberProtocol {
    public func buildDeclMember(format: Format) -> DeclSyntax {
        return build(format: format)
    }
}
