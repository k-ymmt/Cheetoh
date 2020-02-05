//
//  SyntaxBuildable.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/05.
//

import Foundation
import SwiftSyntax

public struct SyntaxValues: CustomStringConvertible {
    var values: [AnyKeyPath: Any] = [:]
    public var description: String {
        return "[" + values.map { "\($0.key): \($0.value)" }.joined(separator: ", ") + "]"
    }
}

public protocol SyntaxBuildable {
    associatedtype BuildType
    associatedtype SelfType: SyntaxBuildable
    var syntax: SyntaxValues { get }
    func environment<V>(_ keyPath: WritableKeyPath<SyntaxValues, V>, _ value: V) -> SelfType

    func build(format: Format) -> BuildType
}
