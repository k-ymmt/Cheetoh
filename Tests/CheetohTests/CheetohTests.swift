import XCTest
@testable import Cheetoh

final class CheetohTests: XCTestCase {
    func testExample() {
        let example = Struct("Foo") {
            Let(name: "hoge", type: TypeIdentifier("Hoge"))
            Var(
                name: "bar",
                type: TypeIdentifier("Bar")
                    .nillable()
                    .genericArguments(TypeIdentifier("Foo"))
            ).accessLevel(.private)
        }.build(format: .init(indent: 4))
        
        XCTAssertEqual(example.description, """
struct Foo {
    let hoge: Hoge
    private var bar: Bar<Foo>?
}

""")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
