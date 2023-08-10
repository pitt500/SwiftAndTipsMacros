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
    func testSampleBuilderMacro() throws{
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
}
