//
//  EnumTests.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2021/08/22.
//

import Foundation
import XCTest
@testable import Cheetoh

private let enumText = """
public enum Foo {
    case foo
    case bar(String)
}

"""

class EnumTests: XCTestCase {
    func testStruct() {
        let e = Enum("Foo") {
            EnumCase("foo")
            EnumCase("bar", associatedValue: [nil: TypeIdentifier("String")])
        }
        .accessLevel(.public)

        XCTAssertEqual(e.build(format: Format(indent: 4)).description, enumText)
    }
}
