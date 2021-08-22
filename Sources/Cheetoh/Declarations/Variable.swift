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

public struct Variable<Mutability: VariableMutability>: SyntaxBuildable, AccessControllable, InitializerProtocol, StaticallyProtocol, OverrideProtocol {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    
    private let name: String
    private let type: TypeIdentifier?
    
    public init(_ name: String, _ type: TypeIdentifier? = nil) {
        self.name = name
        self.type = type
    }
    
    public init<Type>(_ name: String, _ type: Type.Type) {
        self.name = name
        self.type = TypeIdentifier(String(describing: type))
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Variable<Mutability> {
        var variable = self
        variable.syntax[keyPath: keyPath] = value
        
        return variable
    }
    
    public func build(format: Format) -> VariableDeclSyntax {
        VariableDeclSyntax {
            $0.addAttribute(Syntax(SyntaxFactory.makeUnknown("").withLeadingTrivia(.spaces(format.base))))
            if let accessLevel = self.buildAccessLevel() {
                $0.addAttribute(Syntax(accessLevel))
            }
            
            if let staticKeyword = buildStatic(format: format) {
                $0.addAttribute(Syntax(staticKeyword))
            }
            
            if let overrideKeyword = buildOverride(format: format) {
                $0.addAttribute(Syntax(overrideKeyword))
            }
            
            $0.useLetOrVarKeyword(Mutability.keyword)

            $0.addBinding(PatternBindingSyntax {
                $0.usePattern(PatternSyntax(SyntaxFactory.makeIdentifierPattern(identifier: SyntaxFactory.makeIdentifier(name))))
                if let type = type {
                    $0.useTypeAnnotation(TypeAnnotationSyntax {
                        $0.useColon(SyntaxFactory.makeColonToken(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
                        $0.useType(type.build(format: format))
                    })
                }
                if let initializer = buildInitializer(format: format) {
                    $0.useInitializer(initializer)
                }
            }.withTrailingTrivia(.newlines(1)))
        }
    }
}

extension Variable: DeclMemberProtocol, EnumDeclMemberProtocol {
    public func buildDeclMember(format: Format) -> DeclSyntax {
        return DeclSyntax(build(format: format))
    }
}

extension Variable: SourceFileScopeDeclaration {
}

extension Variable: CodeBlockItem {
    public func buildCodeBlockItem(format: Format) -> CodeBlockItemSyntax {
        SyntaxFactory.makeCodeBlockItem(
            item: Syntax(build(format: format)),
            semicolon: nil,
            errorTokens: nil
        )
    }
}
