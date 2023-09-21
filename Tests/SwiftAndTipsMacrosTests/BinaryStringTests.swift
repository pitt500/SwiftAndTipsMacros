/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(Macros)
import Macros

fileprivate let testMacros: [String: Macro.Type] = [
    "binaryString": BinaryStringMacro.self
]
#else
    #error("Macros library is not running")
#endif

final class BinaryStringTests: XCTestCase {
    
    func testBinaryStringMacro_WithIntLiteral() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            #binaryString(111)
            """,
            expandedSource: """
            "1101111"
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testBinaryStringMacro_WithStringLiteral() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            #"""
            #binaryString("Hello")
            """#,
            expandedSource: """
            #binaryString("Hello")
            """,
            diagnostics: [
                DiagnosticSpec(message: "The argument is not an Int literal", line: 1, column: 1)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testBinaryStringMacro_WithVariableOfTypeInt() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            let input = 7
            #binaryString(input)
            """,
            expandedSource: #"""
            let input = 7
            #binaryString(input)
            """#,
            diagnostics: [
                DiagnosticSpec(message: "The argument is not an Int literal", line: 2, column: 1)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
