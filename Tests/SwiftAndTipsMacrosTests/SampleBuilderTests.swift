//
//  SampleBuilderTests.swift
//  
//
//  Created by Pedro Rojas on 05/08/23.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(Macros)
import Macros

fileprivate let testMacros: [String: Macro.Type] = [
    "SampleBuilder": SampleBuilderMacro.self
]
#else
    #error("Macros library is not running")
#endif


final class SampleBuilderTests: XCTestCase {
    func testSampleBuilderMacro_Int_and_String() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Example {
                let x: Int
                let y: String
            }
            """#,
            expandedSource: """
            struct Example {
                let x: Int
                let y: String
                static var sample: [Self] {
                    [
                        .init(x: 0, y: "Hello World"),
                        .init(x: 0, y: "Hello World"),
                        .init(x: 0, y: "Hello World"),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testSampleBuilderMacro_supportedType() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Person {
                let id: UUID
                let item1: String
                let item2: Int
                let item3: Bool
                let item4: Data
                let item5: Date
                let item6: Double
                let item7: Float
                let item8: Int8
                let item9: Int16
                let item10: Int32
                let item11: Int64
                let item12: UInt8
                let item13: UInt16
                let item14: UInt32
                let item15: UInt64
                let item16: URL
                let item17: CGPoint
                let item18: CGFloat
                let item19: CGRect
                let item20: CGSize
                let item21: CGVector
            }
            """#,
            expandedSource: """
            struct Person {
                let id: UUID
                let item1: String
                let item2: Int
                let item3: Bool
                let item4: Data
                let item5: Date
                let item6: Double
                let item7: Float
                let item8: Int8
                let item9: Int16
                let item10: Int32
                let item11: Int64
                let item12: UInt8
                let item13: UInt16
                let item14: UInt32
                let item15: UInt64
                let item16: URL
                let item17: CGPoint
                let item18: CGFloat
                let item19: CGRect
                let item20: CGSize
                let item21: CGVector
                static var sample: [Self] {
                    [
                        .init(id: DataGenerator.default.uuid(), item1: "Hello World", item2: 0, item3: true, item4: DataGenerator.default.data(), item5: DataGenerator.default.date(), item6: 0.0, item7: 0.0, item8: 0, item9: 0, item10: 0, item11: 0, item12: 0, item13: 0, item14: 0, item15: 0, item16: DataGenerator.default.url(), item17: DataGenerator.default.cgpoint(), item18: DataGenerator.default.cgfloat(), item19: DataGenerator.default.cgrect(), item20: DataGenerator.default.cgsize(), item21: DataGenerator.default.cgvector()),
                        .init(id: DataGenerator.default.uuid(), item1: "Hello World", item2: 0, item3: true, item4: DataGenerator.default.data(), item5: DataGenerator.default.date(), item6: 0.0, item7: 0.0, item8: 0, item9: 0, item10: 0, item11: 0, item12: 0, item13: 0, item14: 0, item15: 0, item16: DataGenerator.default.url(), item17: DataGenerator.default.cgpoint(), item18: DataGenerator.default.cgfloat(), item19: DataGenerator.default.cgrect(), item20: DataGenerator.default.cgsize(), item21: DataGenerator.default.cgvector()),
                        .init(id: DataGenerator.default.uuid(), item1: "Hello World", item2: 0, item3: true, item4: DataGenerator.default.data(), item5: DataGenerator.default.date(), item6: 0.0, item7: 0.0, item8: 0, item9: 0, item10: 0, item11: 0, item12: 0, item13: 0, item14: 0, item15: 0, item16: DataGenerator.default.url(), item17: DataGenerator.default.cgpoint(), item18: DataGenerator.default.cgfloat(), item19: DataGenerator.default.cgrect(), item20: DataGenerator.default.cgsize(), item21: DataGenerator.default.cgvector()),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testSampleBuilderMacro_customStruct() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Review {
                let rating: Int
                let time: Date
                let product: Product
            }

            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Product {
                var price: Int
                var description: String
            }
            """#,
            expandedSource: """
            struct Review {
                let rating: Int
                let time: Date
                let product: Product
                static var sample: [Self] {
                    [
                        .init(rating: 0, time: DataGenerator.default.date(), product: Product.sample.first!),
                        .init(rating: 0, time: DataGenerator.default.date(), product: Product.sample.first!),
                        .init(rating: 0, time: DataGenerator.default.date(), product: Product.sample.first!),
                    ]
                }
            }
            struct Product {
                var price: Int
                var description: String
                static var sample: [Self] {
                    [
                        .init(price: 0, description: "Hello World"),
                        .init(price: 0, description: "Hello World"),
                        .init(price: 0, description: "Hello World"),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testSampleBuilderMacro_array() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Product {
                var price: Int
                var description: String
                let array: [Int]
            }
            """#,
            expandedSource: """
            struct Product {
                var price: Int
                var description: String
                let array: [Int]
                static var sample: [Self] {
                    [
                        .init(price: 0, description: "Hello World", array: [0]),
                        .init(price: 0, description: "Hello World", array: [0]),
                        .init(price: 0, description: "Hello World", array: [0]),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_ignore_static_variable() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Example {
                let x: Int
                private var y: String
                static var asd: Self {
                    .init(x: 0, y: "Hello World")
                }
            }
            """#,
            expandedSource: """
            struct Example {
                let x: Int
                private var y: String
                static var asd: Self {
                    .init(x: 0, y: "Hello World")
                }
                static var sample: [Self] {
                    [
                        .init(x: 0, y: "Hello World"),
                        .init(x: 0, y: "Hello World"),
                        .init(x: 0, y: "Hello World"),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testSampleBuilderMacro_ignore_not_stored_properties() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Example {
                let x: Int
                private var y: String {
                    didSet {
                        print("didSet called")
                    }
                    willSet {
                        print("willSet called")
                    }
                }
                static var asd: Self {
                    .init(x: 0, y: "Hello World")
                }
                var z: String {
                    get { y }
                }
                var w: String {
                    get {
                        y
                    }
                    set {
                        y = newValue
                    }
                }
            }
            """#,
            expandedSource: """
            struct Example {
                let x: Int
                private var y: String {
                    didSet {
                        print("didSet called")
                    }
                    willSet {
                        print("willSet called")
                    }
                }
                static var asd: Self {
                    .init(x: 0, y: "Hello World")
                }
                var z: String {
                    get {
                        y
                    }
                }
                var w: String {
                    get {
                        y
                    }
                    set {
                        y = newValue
                    }
                }
                static var sample: [Self] {
                    [
                        .init(x: 0, y: "Hello World"),
                        .init(x: 0, y: "Hello World"),
                        .init(x: 0, y: "Hello World"),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_struct_with_custom_init_one_parameter() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Product {
                var price: Int
                var description: String
            
                init(price: Int) {
                    self.price = price
                    self.description = ""
                }
            }
            """#,
            expandedSource: """
            struct Product {
                var price: Int
                var description: String
            
                init(price: Int) {
                    self.price = price
                    self.description = ""
                }
                static var sample: [Self] {
                    [
                        .init(price: 0),
                        .init(price: 0),
                        .init(price: 0),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_struct_with_custom_init_many_parameter() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Product {
                var price: Int
                var description: String
                var date: Date
                var id: UUID
            
                init(price: Int, date: Date) {
                    self.price = price
                    self.description = ""
                    self.date = date
                    self.id = UUID()
                }
            }
            """#,
            expandedSource: """
            struct Product {
                var price: Int
                var description: String
                var date: Date
                var id: UUID
            
                init(price: Int, date: Date) {
                    self.price = price
                    self.description = ""
                    self.date = date
                    self.id = UUID()
                }
                static var sample: [Self] {
                    [
                        .init(price: 0, date: DataGenerator.default.date()),
                        .init(price: 0, date: DataGenerator.default.date()),
                        .init(price: 0, date: DataGenerator.default.date()),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_struct_with_many_inits() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Product {
                var price: Int
                var description: String
                var date: Date
                var id: UUID
            
                init(price: Int, date: Date) {
                    self.price = price
                    self.description = ""
                    self.date = date
                    self.id = UUID()
                }
            
                init(price: Int, date: Date, id: UUID, description: String) {
                    self.price = price
                    self.description = description
                    self.date = date
                    self.id = id
                }
            }
            """#,
            expandedSource: """
            struct Product {
                var price: Int
                var description: String
                var date: Date
                var id: UUID
            
                init(price: Int, date: Date) {
                    self.price = price
                    self.description = ""
                    self.date = date
                    self.id = UUID()
                }
            
                init(price: Int, date: Date, id: UUID, description: String) {
                    self.price = price
                    self.description = description
                    self.date = date
                    self.id = id
                }
                static var sample: [Self] {
                    [
                        .init(price: 0, date: DataGenerator.default.date(), id: DataGenerator.default.uuid(), description: "Hello World"),
                        .init(price: 0, date: DataGenerator.default.date(), id: DataGenerator.default.uuid(), description: "Hello World"),
                        .init(price: 0, date: DataGenerator.default.date(), id: DataGenerator.default.uuid(), description: "Hello World"),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_dictionary_property() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Product {
                var price: Int
                var description: String
                var dict: [String: Int]
            }
            """#,
            expandedSource: """
            struct Product {
                var price: Int
                var description: String
                var dict: [String: Int]
                static var sample: [Self] {
                    [
                        .init(price: 0, description: "Hello World", dict: ["Hello World": 0]),
                        .init(price: 0, description: "Hello World", dict: ["Hello World": 0]),
                        .init(price: 0, description: "Hello World", dict: ["Hello World": 0]),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_multiple_dictionary_properties() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Example {
                let x: Int
                let y: String
            }

            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Product {
                var price: Int
                var description: String
                var dict1: [String: Int]
                var dict2: [String: [Int]]
                var dict3: [String: [String: Example]]
            }
            """#,
            expandedSource: """
            struct Example {
                let x: Int
                let y: String
                static var sample: [Self] {
                    [
                        .init(x: 0, y: "Hello World"),
                        .init(x: 0, y: "Hello World"),
                        .init(x: 0, y: "Hello World"),
                    ]
                }
            }
            struct Product {
                var price: Int
                var description: String
                var dict1: [String: Int]
                var dict2: [String: [Int]]
                var dict3: [String: [String: Example]]
                static var sample: [Self] {
                    [
                        .init(price: 0, description: "Hello World", dict1: ["Hello World": 0], dict2: ["Hello World": [0]], dict3: ["Hello World": ["Hello World": Example.sample.first!]]),
                        .init(price: 0, description: "Hello World", dict1: ["Hello World": 0], dict2: ["Hello World": [0]], dict3: ["Hello World": ["Hello World": Example.sample.first!]]),
                        .init(price: 0, description: "Hello World", dict1: ["Hello World": 0], dict2: ["Hello World": [0]], dict3: ["Hello World": ["Hello World": Example.sample.first!]]),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_enum() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 5, dataGeneratorType: .default)
            enum MyEnum {
                case case1(String)
                case case2
                case case3(String)
            }
            """#,
            expandedSource: """
            enum MyEnum {
                case case1(String)
                case case2
                case case3(String)
                static var sample: [Self] {
                    [
                        .case1("Hello World"),
                        .case2,
                        .case3("Hello World"),
                        .case1("Hello World"),
                        .case2,
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testSampleBuilderMacro_enum_with_indirect_case() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            struct Example {
                let x: Int
                let y: String
                let myEnum: MyEnum
            }

            @SampleBuilder(numberOfItems: 1, dataGeneratorType: .default)
            enum MyEnum {
                indirect case case1(String, Int, String, String, Example)
                case case2
                case case3(String)
            }
            """#,
            expandedSource: """
            struct Example {
                let x: Int
                let y: String
                let myEnum: MyEnum
                static var sample: [Self] {
                    [
                        .init(x: 0, y: "Hello World", myEnum: MyEnum.sample.first!),
                        .init(x: 0, y: "Hello World", myEnum: MyEnum.sample.first!),
                        .init(x: 0, y: "Hello World", myEnum: MyEnum.sample.first!),
                    ]
                }
            }
            enum MyEnum {
                indirect case case1(String, Int, String, String, Example)
                case case2
                case case3(String)
                static var sample: [Self] {
                    [
                        .case1("Hello World", 0, "Hello World", "Hello World", Example.sample.first!),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testSampleBuilderMacro_enum_with_arrays() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 6, dataGeneratorType: .default)
            enum MyEnum {
                indirect case case1(String, Int, String, [String])
                case case2
            }
            """#,
            expandedSource: """
            enum MyEnum {
                indirect case case1(String, Int, String, [String])
                case case2
                static var sample: [Self] {
                    [
                        .case1("Hello World", 0, "Hello World", ["Hello World"]),
                        .case2,
                        .case1("Hello World", 0, "Hello World", ["Hello World"]),
                        .case2,
                        .case1("Hello World", 0, "Hello World", ["Hello World"]),
                        .case2,
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testSampleBuilderMacro_enum_with_custom_associated_value() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 6, dataGeneratorType: .default)
            enum MyEnum {
                indirect case case1(String, Int, String, [String])
                case case2
                case case3(Product)
            }
            
            @SampleBuilder(numberOfItems: 2, dataGeneratorType: .default)
            struct Product {
                var item1: Int
                var item2: String
            }
            """#,
            expandedSource: """
            enum MyEnum {
                indirect case case1(String, Int, String, [String])
                case case2
                case case3(Product)
                static var sample: [Self] {
                    [
                        .case1("Hello World", 0, "Hello World", ["Hello World"]),
                        .case2,
                        .case3(Product.sample.first!),
                        .case1("Hello World", 0, "Hello World", ["Hello World"]),
                        .case2,
                        .case3(Product.sample.first!),
                    ]
                }
            }
            struct Product {
                var item1: Int
                var item2: String
                static var sample: [Self] {
                    [
                        .init(item1: 0, item2: "Hello World"),
                        .init(item1: 0, item2: "Hello World"),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testSampleBuilderMacro_enum_with_dictionary() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 6, dataGeneratorType: .default)
            enum MyEnum {
                indirect case case1(String, Int, String, [String])
                case case2
                case case3(Product)
                case case4([String: Int])
            }
            
            @SampleBuilder(numberOfItems: 2, dataGeneratorType: .default)
            struct Product {
                var item1: Int
                var item2: String
            }
            """#,
            expandedSource: """
            enum MyEnum {
                indirect case case1(String, Int, String, [String])
                case case2
                case case3(Product)
                case case4([String: Int])
                static var sample: [Self] {
                    [
                        .case1("Hello World", 0, "Hello World", ["Hello World"]),
                        .case2,
                        .case3(Product.sample.first!),
                        .case4(["Hello World": 0]),
                        .case1("Hello World", 0, "Hello World", ["Hello World"]),
                        .case2,
                    ]
                }
            }
            struct Product {
                var item1: Int
                var item2: String
                static var sample: [Self] {
                    [
                        .init(item1: 0, item2: "Hello World"),
                        .init(item1: 0, item2: "Hello World"),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_nested_arrays() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 6, dataGeneratorType: .default)
            struct Test {
                var item1: Int
                var item2: [[String]]
                var item3: [[[[Int]]]]
            }
            """#,
            expandedSource: """
            struct Test {
                var item1: Int
                var item2: [[String]]
                var item3: [[[[Int]]]]
                static var sample: [Self] {
                    [
                        .init(item1: 0, item2: [["Hello World"]], item3: [[[[0]]]]),
                        .init(item1: 0, item2: [["Hello World"]], item3: [[[[0]]]]),
                        .init(item1: 0, item2: [["Hello World"]], item3: [[[[0]]]]),
                        .init(item1: 0, item2: [["Hello World"]], item3: [[[[0]]]]),
                        .init(item1: 0, item2: [["Hello World"]], item3: [[[[0]]]]),
                        .init(item1: 0, item2: [["Hello World"]], item3: [[[[0]]]]),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_nested_dictionaries() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 6, dataGeneratorType: .default)
            enum MyEnum {
                indirect case case1(String, Int, String, [String])
                case case2
                case case3(Product)
                case case4([String: Product])
            }

            @SampleBuilder(numberOfItems: 6, dataGeneratorType: .default)
            struct Test {
                var item1: [[Int]: [[String: [String: [Int: [Int: MyEnum]]]]]]
            }
            """#,
            expandedSource: """
            enum MyEnum {
                indirect case case1(String, Int, String, [String])
                case case2
                case case3(Product)
                case case4([String: Product])
                static var sample: [Self] {
                    [
                        .case1("Hello World", 0, "Hello World", ["Hello World"]),
                        .case2,
                        .case3(Product.sample.first!),
                        .case4(["Hello World": Product.sample.first!]),
                        .case1("Hello World", 0, "Hello World", ["Hello World"]),
                        .case2,
                    ]
                }
            }
            struct Test {
                var item1: [[Int]: [[String: [String: [Int: [Int: MyEnum]]]]]]
                static var sample: [Self] {
                    [
                        .init(item1: [[0]: [["Hello World": ["Hello World": [0: [0: MyEnum.sample.first!]]]]]]),
                        .init(item1: [[0]: [["Hello World": ["Hello World": [0: [0: MyEnum.sample.first!]]]]]]),
                        .init(item1: [[0]: [["Hello World": ["Hello World": [0: [0: MyEnum.sample.first!]]]]]]),
                        .init(item1: [[0]: [["Hello World": ["Hello World": [0: [0: MyEnum.sample.first!]]]]]]),
                        .init(item1: [[0]: [["Hello World": ["Hello World": [0: [0: MyEnum.sample.first!]]]]]]),
                        .init(item1: [[0]: [["Hello World": ["Hello World": [0: [0: MyEnum.sample.first!]]]]]]),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_error_classes() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 1, dataGeneratorType: .default)
            class MyClass {
                
            }
            """#,
            expandedSource: """
            class MyClass {
            
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "@SampleBuilder can only be applied to Structs and Enums",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_error_numberOfItems_equal_to_zero() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 0, dataGeneratorType: .default)
            struct Example {
                let item: Int
            }
            """#,
            expandedSource: """
            struct Example {
                let item: Int
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "'numberOfitems' argument must be greater than zero",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_error_numberOfItems_less_than_zero() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: -1, dataGeneratorType: .default)
            struct Example {
                let item: Int
            }
            """#,
            expandedSource: """
            struct Example {
                let item: Int
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "'numberOfitems' argument must be greater than zero",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_error_enum_with_no_cases() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 5, dataGeneratorType: .default)
            enum Example {
            }
            """#,
            expandedSource: """
            enum Example {
            }
            """,
            diagnostics: [
                DiagnosticSpec(
                    message: "Enum must contain at least one case",
                    line: 1,
                    column: 1,
                    fixIts: [FixItSpec(message: "add a new enum case")]
                )
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderMacro_error_enum_with_associated_values_and_argument_names() throws{
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            @SampleBuilder(numberOfItems: 3, dataGeneratorType: .default)
            enum Example {
                case response(time: Date, name: String, Data)
            }
            """#,
            expandedSource: """
            enum Example {
                case response(time: Date, name: String, Data)
                static var sample: [Self] {
                    [
                        .response(time: DataGenerator.default.date(), name: "Hello World", DataGenerator.default.data()),
                        .response(time: DataGenerator.default.date(), name: "Hello World", DataGenerator.default.data()),
                        .response(time: DataGenerator.default.date(), name: "Hello World", DataGenerator.default.data()),
                    ]
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
