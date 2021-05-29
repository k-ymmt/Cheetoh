//
//  StructTests.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/03/29.
//

import Foundation
import XCTest
@testable import Cheetoh

private let structText = """
public struct Foo: CustomStringConvertible {
    private let string: String

    init(string: String) {
        self.string = string
    }

    func description() -> String {
        return string
    }
}

"""

class StructTests: XCTestCase {
    func testStruct() {
        let s = Struct("Foo") {
            Let("string", String.self)
                .accessLevel(.private)
            Newlines()
            
            Init(["string": .type(String.self)]) {
                Assign(Identifier("self").member("string"), Identifier("string"))
            }
            Newlines()
            
            Func("description") {
                Return(Identifier("string"))
            }.returnType(String.self)
        }.accessLevel(.public)
        .inheritedTypes(CustomStringConvertible.self)
        
        XCTAssertEqual(s.build(format: Format(indent: 4)).description, structText)
    }
}
