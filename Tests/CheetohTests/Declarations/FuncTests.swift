//
//  FuncTests.swift
//  Cheetoh
//
//  Created by Kazuki Yamamoto on 2020/04/11.
//

import Foundation
import XCTest
@testable import Cheetoh

let funcText = """
public func sample(foo: Bar) -> String {
    return "sample"
}

"""

class FuncTests: XCTestCase {
    func testFunc() {
        let f = Func("sample", ParameterVariable("foo", type: TypeIdentifier("Bar"))) {
            Return("sample")
        }
        .accessLevel(.public)
        .returnType(TypeIdentifier("String"))
        
        XCTAssertEqual(f.build(format: .init(indent: 4)).description, funcText)
    }
}
