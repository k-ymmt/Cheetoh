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
    }
    
    Newlines()
    
    Let("hoge", TypeIdentifier("Hoge"))
        .initializer(FunctionCallExpression("Hoge"))

    Newlines()

    Func("main") {
        FunctionCallExpression("print", ["": StringLiteralExpression("Hello World!")])
    }
}.build(format: .init(indent: 4)).write(to: &output)

print(output)
