import Foundation
import Cheetoh

var output: String = ""

SourceFile {
    Import("Foundation")
    
    Newlines()
    
    Struct("Hoge") {
        Let("hoge", String.self)
            .initializer(StringLiteralExpression("hoge"))
        Var("foo", Int.self)
    }.accessLevel(.public)
    
    Newlines()
    
    Let("hoge", TypeIdentifier("Hoge"))
        .initializer(FunctionCallExpression("Hoge", ["foo": IntLiteralExpression(10)]))
        .accessLevel(.private)

    Newlines()

    Func("main") {
        FunctionCallExpression("print", [nil: StringLiteralExpression("Hello World!")])
    }
}.build(format: .init(indent: 4)).write(to: &output)

print(output)
