//
//  Attributes.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2021/08/25.
//

import Foundation
import SwiftSyntax

extension SyntaxValues {
    var attributes: [Attribute]? {
        get {
            values[\Self.attributes] as? [Attribute]
        }
        set {
            values[\Self.attributes] = newValue
        }
    }
}

public protocol Attribute {
    func buildAttribute(format: Format) -> AttributeSyntax
}

public protocol AttributesAttachable: SyntaxBuildable {
    func attributes(_ attributes: [Attribute]) -> SelfType
}

extension AttributesAttachable {
    public func attributes(_ attributes: [Attribute]) -> SelfType {
        return environment(\.attributes, attributes)
    }

    func buildAttributes(format: Format) -> AttributeListSyntax? {
        guard let attributes = syntax.attributes else {
            return nil
        }
        return SyntaxFactory.makeAttributeList(
            attributes.map { $0.buildAttribute(format: format) }.map(Syntax.init)
        )
    }
}

