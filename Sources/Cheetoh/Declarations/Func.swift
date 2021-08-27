//
//  Function.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

public protocol CodeBlockItem {
    func buildCodeBlockItem(format: Format) -> CodeBlockItemSyntax
}

@resultBuilder
public struct CodeBlockBuilder {
    public static func buildBlock(_ items: CodeBlockItem...) -> [CodeBlockItem] {
        return items
    }

    public static func buildOptional(_ items: [CodeBlockItem]?) -> [CodeBlockItem] {
        return items ?? []
    }

    public static func buildEither(first items: [CodeBlockItem]) -> [CodeBlockItem] {
        return items
    }

    public static func buildEither(second items: [CodeBlockItem]) -> [CodeBlockItem] {
        return items
    }

    public static func buildArray(_ items: [[CodeBlockItem]]) -> [CodeBlockItem] {
        return Array(items.joined())
    }
}

public struct Func: SyntaxBuildable, AccessControllable, Throwable, ReturnType, GenericTypeParameters, StaticallyProtocol, OverrideProtocol, AttributesAttachable {
    public var syntax: SyntaxValues = SyntaxValues()

    private let name: String
    private let body: [CodeBlockItem]
    private let parameters: [ParameterVariable]

    public init(_ name: String, parameters: ParameterVariableList, @CodeBlockBuilder body: () -> [CodeBlockItem]) {
        self.name = name
        self.body = body()
        self.parameters = parameters.variables
    }
    
    public init(_ name: String, @CodeBlockBuilder body: () -> [CodeBlockItem]) {
        self.name = name
        self.body = body()
        self.parameters = []
    }
    
    public init(_ name: String) {
        self.name = name
        self.body = []
        self.parameters = []
    }
    
    public init(_ name: String, parameters: ParameterVariableList) {
        self.name = name
        self.body = []
        self.parameters = parameters.variables
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> FunctionDeclSyntax {
        FunctionDeclSyntax {
            let incrementedIndentFormat = format.incrementIndent()
            $0.addAttribute(Syntax(SyntaxFactory.makeUnknown("").withLeadingTrivia(.spaces(format.base))))
            if let accessLevel = buildAccessLevel() {
                $0.addAttribute(Syntax(accessLevel))
            }
            
            if let staticKeyword = buildStatic(format: format) {
                $0.addAttribute(Syntax(staticKeyword))
            }
            
            if let overrideKeyword = buildOverride(format: format) {
                $0.addAttribute(Syntax(overrideKeyword))
            }
            
            $0.useFuncKeyword(SyntaxFactory.makeFuncKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
            $0.useIdentifier(SyntaxFactory.makeIdentifier(name))
            if let generics = buildGenericTypeParameters(format: format) {
                $0.useGenericParameterClause(generics)
            }
            $0.useSignature(FunctionSignatureSyntax {
                if let throwable = buildThrowable() {
                    $0.useThrowsOrRethrowsKeyword(throwable)
                }

                $0.useInput(ParameterClauseSyntax {
                    $0.useLeftParen(SyntaxFactory.makeLeftParenToken())
                    
                    if !parameters.isEmpty {
                        let lastIndex = parameters.count - 1
                        for parameter in parameters[0..<lastIndex] {
                            var parameter = parameter.build(format: format)
                            parameter.trailingComma = SyntaxFactory.makeCommaToken(leadingTrivia: .zero, trailingTrivia: .spaces(1))
                            $0.addParameter(parameter)
                            
                        }
                        $0.addParameter(parameters[lastIndex].build(format: format))
                    }
                    
                    $0.useRightParen(SyntaxFactory.makeRightParenToken())
                })
                if let throwable = buildThrowable() {
                    $0.useThrowsOrRethrowsKeyword(throwable)
                }
                if let returnType = buildReturnType(format: format) {
                    $0.useOutput(returnType)
                }
            })
            $0.useBody(CodeBlockSyntax {
                $0.useLeftBrace(SyntaxFactory.makeLeftBraceToken(leadingTrivia: .spaces(1), trailingTrivia: .newlines(1)))
                for item in body {
                    $0.addStatement(item.buildCodeBlockItem(format: format)
                        .withLeadingTrivia(.spaces(incrementedIndentFormat.base))
                        .withTrailingTrivia(.newlines(1))
                    )
                }
                $0.useRightBrace(SyntaxFactory.makeRightBraceToken(leadingTrivia: .spaces(format.base), trailingTrivia: .newlines(1)))
            })
        }
    }
}

extension Func: DeclMemberProtocol, EnumDeclMemberProtocol{
    public func buildDeclMember(format: Format) -> DeclSyntax {
        DeclSyntax(build(format: format))
    }
}

extension Func: SourceFileScopeDeclaration {
}
