# SwiftAndTipsMacros
This repository contains a list of Swift Macros to make your coding live on Apple ecosystem simpler and more productive.

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [Requirements](#requirements)
- [Macros](#macros)
  - [#binaryString](#binarystring)
  - [@SampleBuilder](#samplebuilder)
    - [How to use it?](#how-to-use-it)
    - [Supported Foundation Types](#supported-foundation-types)
    - [`.default` Generator Values](#default-generator-values)
    - [Custom Types](#custom-types)
    - [Enums](#enums)
  - [@SampleBuilderItem](#samplebuilderitem)
- [Installation](#installation)
- [Limitations](#limitations)
  - [@SampleBuilder](#samplebuilder-1)
- [Future Work](#future-work)
  - [@SampleBuilder](#samplebuilder-2)
- [Contributing](#contributing)
- [Contact](#contact)
- [License](#license)

<!-- /code_chunk_output -->

## Requirements
- Xcode 15 or above.
- Swift 5.9 or above.

## Macros
### #binaryString
**\#binaryString** is a freestanding macro that will convert an Integer literal into a binary string representation:
```swift
let x = #binaryString(10)
/*
expanded code:
"1010"
*/
print(x) // Output: "1010"
```
> This macro was created as a tutorial to explain how macros work. It would be simpler to create a function to do this instead :). Learn more here: TBD

### @SampleBuilder
The goal of @SampleBuilder is simple: Create an array of sample data from your models to be used in SwiftUI previews, unit tests or anything that requires mock data without the paying of write it donw from scratch.

#### How to use it?
1. Import `SwiftAndTipsMacros` and `DataGenerator`.
2. Attach `@SampleBuilder` to an `struct` or `enum`.
3. Provide the number of items you want for your sample.
4. Provide the type of data generator you want to use:
    * `default` will generate a fixed value all the time (ideal for unit tests).
    * `random` will generate a random value for each property requested in the initialization.

In this example, we are using the `default` generator to generate 10 items: 
```swift
// 1
import SwiftAndTipsMacros
import DataGenerator
// 2
@SampleBuilder(
    numberOfItems: 10, // 3
    dataGeneratorType: .default // 4
)
struct Example {
    let item1: String
    let item2: Int
    /*
    expanded code:
    static var sample: [Self] {
        [
            .init(item1: DataGenerator.default.string(), item2: DataGenerator.default.int()),
            .init(item1: DataGenerator.default.string(), item2: DataGenerator.default.int()),
            .init(item1: DataGenerator.default.string(), item2: DataGenerator.default.int()),
            .init(item1: DataGenerator.default.string(), item2: DataGenerator.default.int()),
            .init(item1: DataGenerator.default.string(), item2: DataGenerator.default.int()),
            .init(item1: DataGenerator.default.string(), item2: DataGenerator.default.int()),
            .init(item1: DataGenerator.default.string(), item2: DataGenerator.default.int()),
            .init(item1: DataGenerator.default.string(), item2: DataGenerator.default.int()),
            .init(item1: DataGenerator.default.string(), item2: DataGenerator.default.int()),
            .init(item1: DataGenerator.default.string(), item2: DataGenerator.default.int()),
        ]
    }
    */
}
...
for element in Example.sample {
    print(element.item1, element.item2)
}
/*
Output:
Hello World 0
Hello World 0
Hello World 0
Hello World 0
Hello World 0
Hello World 0
Hello World 0
Hello World 0
Hello World 0
Hello World 0
*/
``````

Now, if you need a more realistic data, you can use `random` generator type:
```swift
@SampleBuilder(numberOfItems: 10, dataGeneratorType: .random)
struct Example {
    let item1: String
    let item2: Int
    /*
    expanded code:
    static var sample: [Self] {
        [
            .init(item1: DataGenerator.random().string(), item2: DataGenerator.random().int()),
            .init(item1: DataGenerator.random().string(), item2: DataGenerator.random().int()),
            .init(item1: DataGenerator.random().string(), item2: DataGenerator.random().int()),
            .init(item1: DataGenerator.random().string(), item2: DataGenerator.random().int()),
            .init(item1: DataGenerator.random().string(), item2: DataGenerator.random().int()),
            .init(item1: DataGenerator.random().string(), item2: DataGenerator.random().int()),
            .init(item1: DataGenerator.random().string(), item2: DataGenerator.random().int()),
            .init(item1: DataGenerator.random().string(), item2: DataGenerator.random().int()),
            .init(item1: DataGenerator.random().string(), item2: DataGenerator.random().int()),
            .init(item1: DataGenerator.random().string(), item2: DataGenerator.random().int()),
        ]
    }
    */
}
...
for element in Example.sample {
    print(element.item1, element.item2)
}
/*
Output:
1234-2121-1221-1211 738
6760 Nils Mall Suite 390, Kesslerstad, WV 53577-7421 192
yazminzemlak1251 913
lelahdaugherty 219
Tony 228
Jessie 826
alanvonrueden6307@example.com 864
Enola 858
Fay 736
myrtismcdermott@example.net 859
*/
``````

#### Supported Foundation Types
The current supported list includes:
- `UUID`
- `Array`*
- `Dictionary`*
- `String`
- `Int`
- `Bool`
- `Data`
- `Date`
- `Double`
- `Float`
- `Int8`
- `Int16`
- `Int32`
- `Int64`
- `UInt8`
- `UInt16`
- `UInt32`
- `UInt64`
- `URL`
- `CGPoint`
- `CGFloat`
- `CGRect`
- `CGSize`
- `CGVector`

> \* It includes nested types too!

More types will be supported soon.

#### `.default` Generator Values
| Type | Value |
| - | - |
| `UUID` | 00000000-0000-0000-0000-000000000000 (auto increasing) |
| `String` | "Hello World" |
| `Int` | 0 |
| `Bool` | `true` |
| `Data` | Data() |
| `Date` | Date(timeIntervalSinceReferenceDate: 0) |
| `Double` | 0.0 |
| `Float` | 0.0 |
| `Int8` | 0 |
| `Int16` | 0 |
| `Int32` | 0 |
| `Int64` | 0 |
| `UInt8` | 0 |
| `UInt16` | 0 |
| `UInt32` | 0 |
| `UInt64` | 0 |
| `URL` | URL(string: "https://www.apple.com")! |
| `CGPoint` | `CGPoint()` |
| `CGFloat` | `CGFloat()` |
| `CGRect` | `CGRect()` |
| `CGSize` | `CGSize()` |
| `CGVector` | `CGVector()` |


#### Custom Types
You can add `@SampleBuilder` to all your custom types to generate sample data from those types. Here's an example:

```swift
@SampleBuilder(numberOfItems: 3, dataGeneratorType: .random)
struct Review {
    let rating: Int
    let time: Date
    let product: Product
    /*
    expanded code:
    static var sample: [Self] {
        [
            .init(rating: DataGenerator.random().int(), time: DataGenerator.random().date(), product: Product.sample.first!),
            .init(rating: DataGenerator.random().int(), time: DataGenerator.random().date(), product: Product.sample.first!),
            .init(rating: DataGenerator.random().int(), time: DataGenerator.random().date(), product: Product.sample.first!),
        ]
    }
    */
}

@SampleBuilder(numberOfItems: 3, dataGeneratorType: .random)
struct Product {
    var price: Int
    var description: String
    /*
    expanded code:
    static var sample: [Self] {
        [
            .init(price: DataGenerator.random().int(), description: DataGenerator.random().string()),
            .init(price: DataGenerator.random().int(), description: DataGenerator.random().string()),
            .init(price: DataGenerator.random().int(), description: DataGenerator.random().string()),
        ]
    }
    */
}
```
> To generate the sample property in structs, we always take the initialize with the longest number of parameters available. If there are no initializers available, we use the memberwise init.

#### Enums
Enums are also supported by `@SampleBuilder`.
```swift
@SampleBuilder(numberOfItems: 6, dataGeneratorType: .random)
enum MyEnum {
    indirect case case1(String, Int, String, [String])
    case case2
    case case3(Product)
    case case4([String: Product])

    /*
    expanded code:
    static var sample: [Self] {
        [
            .case1(DataGenerator.random().string(), DataGenerator.random().int(), DataGenerator.random().string(), [DataGenerator.random().string()]),
            .case2,
            .case3(Product.sample.first!),
            .case4([DataGenerator.random().string(): Product.sample.first!]),
            .case1(DataGenerator.random().string(), DataGenerator.random().int(), DataGenerator.random().string(), [DataGenerator.random().string()]),
            .case2,
        ]
    }
    */
}
```

To generate the sample for enums, we are adding each case to sample array one by one and starting over if `numberOfItems` is larger than the number of cases.

### @SampleBuilderItem
If you want to customize your sample data even further for `.random` generator, you can use `@SampleBuilderItem` to specify the type of data you want to generate.

The following list shows the supported categories:
* String:
    - `firstName`
    - `lastName`
    - `fullName`
    - `email`
    - `address`
    - `appVersion`
    - `creditCardNumber`
    - `companyName`
    - `username`
* Double:
    - `price`
* URL:
    - `url` (generic web link)
    - `image` (image url)

More category will be added soon.

Here's an example:
```swift
@SampleBuilder(numberOfItems: 3, dataGeneratorType: .random)
struct Profile {
    @SampleBuilderItem(category: .firstName)
    let firstName: String
    
    @SampleBuilderItem(category: .lastName)
    let lastName: String
    
    @SampleBuilderItem(category: .image(width: 300, height: 300))
    let profileImage: URL
    /*
    expanded code:
    static var sample: [Self] {
        [
            .init(firstName: DataGenerator.random(dataCategory: .init(rawValue: "firstName")).string(), lastName: DataGenerator.random(dataCategory: .init(rawValue: "lastName")).string(), profileImage: DataGenerator.random(dataCategory: .init(rawValue: "image(width:300,height:300)")).url()),
            .init(firstName: DataGenerator.random(dataCategory: .init(rawValue: "firstName")).string(), lastName: DataGenerator.random(dataCategory: .init(rawValue: "lastName")).string(), profileImage: DataGenerator.random(dataCategory: .init(rawValue: "image(width:300,height:300)")).url()),
            .init(firstName: DataGenerator.random(dataCategory: .init(rawValue: "firstName")).string(), lastName: DataGenerator.random(dataCategory: .init(rawValue: "lastName")).string(), profileImage: DataGenerator.random(dataCategory: .init(rawValue: "image(width:300,height:300)")).url()),
        ]
    }
    */
}

/*
Output: 
Sylvia Ullrich https://picsum.photos/300/300
Precious Schneider https://picsum.photos/300/300
Nyasia Tromp https://picsum.photos/300/300
*/
```

> @SampleBuilderItem only works with `random` generator in structs. If you use this macro within `default` generator, a warning will appear indicating that macro is redundand.


## Installation
```swift
import PackageDescription

let package = Package(
  name: "<TARGET_NAME>",
  dependencies: [
  	// ...
    .package(url: "https://github.com/pitt500/SwiftAndTipsMacros.git", branch: "main")
  	// ...
  ]
)
```

## Limitations
### @SampleBuilder
* Conflict with #Preview and expanded sample code.
* Both `SwiftAndTipsMacros` and `DataGenerator` are required to be imported in order to make `@SampleBuilder` work. I've explored another alternative using `@_exported` that will reimport `DataGenerator` directly from `SwiftAndTipsMacros`, allowing you to just requiring one import, however, using [underscored attributes](https://github.com/apple/swift/blob/main/docs/ReferenceGuides/UnderscoredAttributes.md) is not recommended because it may break your code after a new Swift release. 
> If you want more information about `@_exported`, watch this [video](https://youtu.be/xU6btygja5Y).

## Future Work

### @SampleBuilder
    * Adding support to CGPoint and more types in random generator mode.
    * Remove the importing of DataGeneration once `@_exported` can be used publicly.
* Adding more macros useful for your development.

## Contributing
There are a lot of work to do, if you want to contribute adding a new macro or fixing an existing one, feel free to fork this project and follow these rules before creating a PR:
1. Include unit tests in your PR (unless is just to fix a typo).
2. Please add a description in your PR with the purpose of your change or new macro.

## Contact
If you have any feedback, I would love to hear from you. Please feel free to reach out to me through any of my social media channels:

* [Youtube](https://youtube.com/@swiftandtips)
* [Twitter](https://twitter.com/swiftandtips)
* [LinkedIn](https://www.linkedin.com/in/pedrorojaslo/)
* [Mastodon](https://iosdev.space/@swiftandtips)

Thanks you, and have a great day! 😄

## License
TBD