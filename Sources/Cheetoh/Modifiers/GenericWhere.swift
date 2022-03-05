//
//  GenericWhere.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/03/01.
//

import Foundation
import SwiftSyntax

public protocol GenericWhereProtocol: SyntaxBuildable {
    func genericWhere(_ requirements: RequirementType...) -> SelfType
}

extension GenericWhereProtocol {
    public func genericWhere(_ requirements: RequirementType...) -> SelfType {
        return environment(\.genericWhere, requirements)
    }

    func buildGenericWhere(format: Format) -> GenericWhereClauseSyntax? {
        guard let requirements = syntax.genericWhere, !requirements.isEmpty else {
            return nil
        }

        return GenericWhereClauseSyntax {
            $0.useWhereKeyword(SyntaxFactory.makeWhereKeyword(
                leadingTrivia: .spaces(1),
                trailingTrivia: .spaces(1)
            ))

            var iter = requirements.makeIterator()
            var next = iter.next()

            while let requirement = next {
                $0.addRequirement(GenericRequirementSyntax {
                    $0.useBody(requirement.build(format: format))

                    next = iter.next()
                    if next != nil {
                        $0.useTrailingComma(SyntaxFactory.makeCommaToken(
                            leadingTrivia: .zero,
                            trailingTrivia: .spaces(1)
                        ))
                    }
                })
            }
        }
    }
}

extension SyntaxValues {
    var genericWhere: [RequirementType]? {
        get {
            values[\Self.genericWhere] as? [RequirementType]
        }
        set {
            values[\Self.genericWhere] = newValue
        }
    }
}
