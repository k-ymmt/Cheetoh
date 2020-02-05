# Cheetoh

[SwiftSyntax](https://github.com/apple/swift-syntax) wrapper for Code Generation like [SwiftSyntaxBuilder](https://github.com/apple/swift-syntax/tree/master/Sources/SwiftSyntaxBuilder).


## Example

```swift
let fooStruct = Struct("Foo") {
    Let(name: "hoge", type: TypeIdentifier("Hoge"))
        .initializer(StringLiteralExpression("hoge"))
    Var(name: "bar", type: TypeIdentifier("Bar")
        .nillable()
        .genericArguments(TypeIdentifier("Foo"))
    ).accessLevel(.private)
    .initializer(StringLiteralExpression("bar"))
}.build(format: Format(indent: 4))

print(fooStruct.description)
```

Output:

```swift
struct Foo {
    let hoge: Hoge = "hoge"
    private var bar: Bar<Foo>? = "bar"
}
```

## Supports
 
- SourceFile
    - [ ] Import
    - [ ] Type Declaration
    - [ ] Top-level function
    - [ ] Top-level variable

- Types
    - [ ] Class
    - [x] Struct
    - [ ] Enum

- Function
    - [x] Declaration
    - [x] Parameters
    - [x] Return Type
    - [x] throws, rethrows
    - [ ] Body

- Variable
    - [x] let
    - [x] var

- Generics
    - [x] Parameters
    - [ ] Inherited Type
    - [ ] where

- [x] Access Control(private, fileprivate, internal, public)
    - `open` currently not supported(`SyntaxFactory.makeOpenKeyword()` not found).
- [x] Initialize
- [x] Nillable type
- [ ] `@` Attributes