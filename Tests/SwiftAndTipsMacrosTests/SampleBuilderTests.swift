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
            @SampleBuilder(numberOfItems: 3)
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
            @SampleBuilder(numberOfItems: 3)
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
                        .init(id: UUID(), item1: "Hello World", item2: 0, item3: true, item4: Data(), item5: Date(), item6: 0, item7: 0, item8: 0, item9: 0, item10: 0, item11: 0, item12: 0, item13: 0, item14: 0, item15: 0, item16: URL(string: "https://www.apple.com")!, item17: CGPoint(), item18: 0, item19: CGRect(), item20: CGSize(), item21: CGVector()),
                        .init(id: UUID(), item1: "Hello World", item2: 0, item3: true, item4: Data(), item5: Date(), item6: 0, item7: 0, item8: 0, item9: 0, item10: 0, item11: 0, item12: 0, item13: 0, item14: 0, item15: 0, item16: URL(string: "https://www.apple.com")!, item17: CGPoint(), item18: 0, item19: CGRect(), item20: CGSize(), item21: CGVector()),
                        .init(id: UUID(), item1: "Hello World", item2: 0, item3: true, item4: Data(), item5: Date(), item6: 0, item7: 0, item8: 0, item9: 0, item10: 0, item11: 0, item12: 0, item13: 0, item14: 0, item15: 0, item16: URL(string: "https://www.apple.com")!, item17: CGPoint(), item18: 0, item19: CGRect(), item20: CGSize(), item21: CGVector()),
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
            @SampleBuilder(numberOfItems: 3)
            struct Review {
                let rating: Int
                let time: Date
                let product: Product
            }

            @SampleBuilder(numberOfItems: 3)
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
                        .init(rating: 0, time: Date(), product: Product.sample.first!),
                        .init(rating: 0, time: Date(), product: Product.sample.first!),
                        .init(rating: 0, time: Date(), product: Product.sample.first!),
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
            @SampleBuilder(numberOfItems: 3)
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
            @SampleBuilder(numberOfItems: 3)
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
            @SampleBuilder(numberOfItems: 3)
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
}
