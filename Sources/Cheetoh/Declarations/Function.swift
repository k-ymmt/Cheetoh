//
//  Function.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation
import SwiftSyntax

protocol CodeBlockItem {
    func buildCodeBlockItem(format: Format) -> CodeBlockItemSyntax
}

@_functionBuilder
struct CodeBlockBuilder {
    static func buildBlock(_ items: CodeBlockItem...) -> [CodeBlockItem] {
        return items
    }
}

public struct Function: SyntaxBuildable, AccessControllable, Throwable, Parameters, ReturnType, GenericTypeParameters {
    public var syntax: SyntaxValues = SyntaxValues()

    private let name: String
    private let body: [CodeBlockItem]
    
    init(_ name: String, @CodeBlockBuilder body: () -> [CodeBlockItem]) {
        self.name = name
        self.body = body()
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> FunctionDeclSyntax {
        FunctionDeclSyntax {
            $0.addAttribute(SyntaxFactory.makeUnknown("").withLeadingTrivia(.spaces(format.base)))
            if let accessLevel = buildAccessLevel() {
                $0.addAttribute(accessLevel)
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
                
                $0.useInput(buildParameters(format: format))
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
                    $0.addStatement(item.buildCodeBlockItem(format: format))
                }
                $0.useRightBrace(SyntaxFactory.makeRightBraceToken(leadingTrivia: .newlines(1), trailingTrivia: .newlines(1)))
            })
        }
    }
}

extension Function: DeclMemberProtocol {
    public func buildDeclMember(format: Format) -> DeclSyntax {
        return build(format: format)
    }
}
