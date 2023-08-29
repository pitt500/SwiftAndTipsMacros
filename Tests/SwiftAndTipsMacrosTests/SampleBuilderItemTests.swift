//
//  SampleBuilderItemTests.swift
//
//
//  Created by Pedro Rojas on 28/08/23.
//

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(Macros)
import Macros

fileprivate let testMacros: [String: Macro.Type] = [
    "SampleBuilderItem": SampleBuilderItemMacro.self
]
#else
    #error("Macros library is not running")
#endif

final class SampleBuilderItemTests: XCTestCase {
    
    func testSampleBuilderItemMacro_testNotYetDefined() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .email)
                let item2: String
            }
            """,
            expandedSource: """
            struct Example {
                let item1: Int
            
                let item2: String
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}

