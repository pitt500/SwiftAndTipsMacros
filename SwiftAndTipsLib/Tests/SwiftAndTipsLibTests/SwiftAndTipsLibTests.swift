import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(SwiftAndTipsLibMacros)
import SwiftAndTipsLibMacros

let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self,
    "binaryString": BinaryStringMacro.self
]
#endif

final class SwiftAndTipsLibTests: XCTestCase {
    func testMacro() throws {
        #if canImport(SwiftAndTipsLibMacros)
        assertMacroExpansion(
            """
            #stringify(a + b)
            """,
            expandedSource: """
            (a + b, "a + b")
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithStringLiteral() throws {
        #if canImport(SwiftAndTipsLibMacros)
        assertMacroExpansion(
            #"""
            #stringify("Hello, \(name)")
            """#,
            expandedSource: #"""
            ("Hello, \(name)", #""Hello, \(name)""#)
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testBinaryStringMacro() throws {
        #if canImport(SwiftAndTipsLibMacros)
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
    
    func testMacro_using_a_string() throws {
        #if canImport(SwiftAndTipsLibMacros)
        assertMacroExpansion(
            #"""
            #binaryString("Hello")
            """#,
            expandedSource: """
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
    
    func testMacro_transforming_variable() throws {
        #if canImport(SwiftAndTipsLibMacros)
        assertMacroExpansion(
            """
            let input = 7
            #binaryString(input)
            """,
            expandedSource: #"""
            let input = 7
            """#,
            diagnostics: [
                DiagnosticSpec(message: "The argument is not an Int literal", line: 1, column: 1)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
