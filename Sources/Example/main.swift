import Foundation
import Cheetoh

var output: String = ""

SourceFile {
    Import("Foundation")
    
    Newlines()
    
    Struct("Hoge") {
        Let("hoge", String.self)
            .initializer("hoge")
        Var("foo", Int.self)
    }.accessLevel(.public)
    
    Newlines()
    
    Let("hoge", TypeIdentifier("Hoge"))
        .initializer(Call("Hoge", ["foo": 10]))
        .accessLevel(.private)

    Newlines()

    Func("main") {
        Call("print", [nil: "Hello World!"])
    }
}.build(format: .init(indent: 4)).write(to: &output)

print(output)
