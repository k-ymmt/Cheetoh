import Foundation
import Cheetoh

var output: String = ""

Struct("Foo") {
    Let(name: "hoge", type: TypeIdentifier("Hoge"))
        .initializer(StringLiteralExpression("hoge"))
    Var(name: "bar", type: TypeIdentifier("Bar")
        .nillable()
        .genericArguments(TypeIdentifier("Foo"))
    ).accessLevel(.private)
    .initializer(StringLiteralExpression("bar"))
}.build(format: Format(indent: 4)).write(to: &output)

print(output)
