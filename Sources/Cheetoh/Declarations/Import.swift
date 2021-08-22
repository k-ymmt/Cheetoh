//
//  Import.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/08.
//

import Foundation
import SwiftSyntax

public struct Import: SyntaxBuildable {
    public var syntax: SyntaxValues = SyntaxValues()
    
    private let moduleName: String
    
    public init(_ moduleName: String) {
        self.moduleName = moduleName
    }
    
    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> Import {
        var me = self
        me.syntax[keyPath: keyPath] = value

        return me
    }
    
    public func build(format: Format) -> ImportDeclSyntax {
        ImportDeclSyntax {
            $0.useImportTok(SyntaxFactory.makeImportKeyword(leadingTrivia: .zero, trailingTrivia: .spaces(1)))
            $0.addPathComponent(AccessPathComponentSyntax {
                $0.useName(SyntaxFactory.makeIdentifier(moduleName).withTrailingTrivia(.newlines(1)))
            })
        }
    }
}

extension Import: DeclMemberProtocol, EnumDeclMemberProtocol {
    public func buildDeclMember(format: Format) -> DeclSyntax {
        DeclSyntax(build(format: format))
    }
}

extension Import: SourceFileScopeDeclaration {
}
