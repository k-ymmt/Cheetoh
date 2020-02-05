//
//  Format.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/02/01.
//

import Foundation

public struct Format {
    public let indent: Int
    public let base: Int
    
    public init(indent: Int, base: Int = 0) {
        self.indent = indent
        self.base = base
    }
    
    public func incrementIndent() -> Format {
        return .init(indent: indent, base: base + indent)
    }
}
