# Cheetoh

[SwiftSyntax](https://github.com/apple/swift-syntax) wrapper for Code Generation like [SwiftSyntaxBuilder](https://github.com/apple/swift-syntax/tree/master/Sources/SwiftSyntaxBuilder).


## Example

```swift
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
```

Output:

```swift
import Foundation

public struct Hoge {
    let hoge: String = "hoge"
    var foo: Int
}

private let hoge: Hoge = Hoge(foo: 10)

func main() {
    print("Hello World!")
}

```

## Supports
 
- SourceFile
    - [x] Import
    - [ ] Type Declaration
    - [x] Top-level function
    - [x] Top-level variable

- Types
    - [ ] Class
    - [x] Struct
    - [ ] Enum

- Function
    - [x] Declaration
    - [x] Parameters
    - [x] Return Type
    - [x] throws, rethrows
    - [x] Body

- Variable
    - [x] let
    - [x] var

- Generics
    - [x] Parameters
    - [ ] Inherited Type
    - [ ] where

- Literal
    - [x] Int
    - [x] Float
    - [x] String
    - [ ] Array
    - [ ] Dictionary

- Expression
    - [x] Literal
    - [x] Call Function
    - [ ] Method Chaining
    - [ ] Optional Chaining

- [x] Access Control(private, fileprivate, internal, public)
    - `open` currently not supported(`SyntaxFactory.makeOpenKeyword()` not found).
- [x] Initialize
- [x] Nillable type
- [ ] `@` Attributes