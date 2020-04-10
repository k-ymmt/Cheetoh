//
//  Init.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/03/30.
//

import Foundation
import SwiftSyntax

public struct Init: SyntaxBuildable, AccessControllable, Throwable, GenericTypeParameters {
    public var syntax: SyntaxValues = SyntaxValues()

    private let body: [CodeBlockItem]
    private let parameters: [ParameterVariable]
    
    public init(@CodeBlockBuilder body: () -> [CodeBlockItem]) {
        self.body = body()
        self.parameters = []
    }
    
    public init(_ parameters: ParameterVariable..., @CodeBlockBuilder body: () -> [CodeBlockItem]) {
        self.body = body()
        self.parameters = parameters
    }
    
    public init(@CodeBlockBuilder body: () -> CodeBlockItem) {
        self.body = [body()]
        self.parameters = []
    }
    
    public init(_ parameters: ParameterVariable..., @CodeBlockBuilder body: () -> CodeBlockItem) {
        self.body = [body()]
        self.parameters = parameters
    }
    
    public init(_ parameters: ParameterVariable..., emptyBody: () -> Void) {
        self.body = []
        self.parameters = parameters
    }
    
    public init(emptyBody: () -> Void) {
        self.body = []
        self.parameters = []
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Self {
        var me = self
        me.syntax[keyPath: keyPath] = value
        
        return me
    }
    
    public func build(format: Format) -> InitializerDeclSyntax {
        InitializerDeclSyntax {
            $0.addAttribute(SyntaxFactory.makeUnknown("")
                .withLeadingTrivia(.spaces(format.base)))
            if let accessLevel = buildAccessLevel() {
                $0.addAttribute(accessLevel)
            }
            
            $0.useInitKeyword(SyntaxFactory.makeInitKeyword())
            $0.useParameters(ParameterClauseSyntax {
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
            $0.useBody(CodeBlockSyntax {
                $0.useLeftBrace(SyntaxFactory.makeLeftBraceToken(
                    leadingTrivia: .spaces(1),
                    trailingTrivia: .newlines(1)
                ))
                
                let incrementedIndentFormat = format.incrementIndent()
                
                for item in body {
                    $0.addStatement(item.buildCodeBlockItem(format: format)
                        .withLeadingTrivia(.spaces(incrementedIndentFormat.base))
                        .withTrailingTrivia(.newlines(1))
                    )
                }
                $0.useRightBrace(SyntaxFactory.makeRightBraceToken(
                    leadingTrivia: .spaces(format.base),
                    trailingTrivia: .newlines(1)
                ))
            })
        }
    }
}

extension Init: DeclMemberProtocol {
    public func buildDeclMember(format: Format) -> DeclSyntax {
        return build(format: format)
    }
}
