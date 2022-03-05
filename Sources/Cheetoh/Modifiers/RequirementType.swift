//
//  RequirementType.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/03/05.
//

import Foundation
import SwiftSyntax

public enum RequirementType {
    case conformance(ConformanceRequirement)
    case sameType(SameTypeRequirement)
}

public struct ConformanceRequirement: SyntaxBuildable {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    let leftType: TypeIdentifier
    let rightType: TypeIdentifier

    public init(_ leftType: TypeIdentifier, _ rightType: TypeIdentifier) {
        self.leftType = leftType
        self.rightType = rightType
    }

    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> ConformanceRequirement {
        var type = self
        type.syntax[keyPath: keyPath] = value
        return type
    }

    public func build(format: Format) -> ConformanceRequirementSyntax {
        ConformanceRequirementSyntax {
            $0.useLeftTypeIdentifier(leftType.build(format: format))
            $0.useColon(SyntaxFactory.makeColonToken(
                leadingTrivia: .zero,
                trailingTrivia: .spaces(1)
            ))
            $0.useRightTypeIdentifier(rightType.build(format: format))
        }
    }
}

public struct SameTypeRequirement: SyntaxBuildable {
    public private(set) var syntax: SyntaxValues = SyntaxValues()
    let leftType: TypeIdentifier
    let rightType: TypeIdentifier

    public init(_ leftType: TypeIdentifier, _ rightType: TypeIdentifier) {
        self.leftType = leftType
        self.rightType = rightType
    }

    public func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> SameTypeRequirement {
        var type = self
        type.syntax[keyPath: keyPath] = value
        return type
    }

    public func build(format: Format) -> SameTypeRequirementSyntax {
        SameTypeRequirementSyntax {
            $0.useLeftTypeIdentifier(leftType.build(format: format))
            $0.useEqualityToken(SyntaxFactory.makeEqualToken(
                leadingTrivia: .spaces(1),
                trailingTrivia: .spaces(1)
            ))
            $0.useRightTypeIdentifier(rightType.build(format: format))
        }
    }
}

extension RequirementType {
    func build(format: Format) -> Syntax {
        switch self {
        case .conformance(let conformance):
            return Syntax(conformance.build(format: format))
        case .sameType(let sameType):
            return Syntax(sameType.build(format: format))
        }
    }
}
