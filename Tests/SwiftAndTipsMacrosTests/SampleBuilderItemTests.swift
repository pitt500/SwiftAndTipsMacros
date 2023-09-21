/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

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
    
    func testSampleBuilderItemMacro_email_category_and_string_property() throws {
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
    func testSampleBuilderItemMacro_firstName_category_and_string_property() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .firstName)
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
    func testSampleBuilderItemMacro_lastName_category_and_string_property() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .lastName)
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
    func testSampleBuilderItemMacro_fullName_category_and_string_property() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .fullName)
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
    func testSampleBuilderItemMacro_address_category_and_string_property() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .address)
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
    func testSampleBuilderItemMacro_appVersion_category_and_string_property() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .appVersion)
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
    func testSampleBuilderItemMacro_creditCardNumber_category_and_string_property() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .creditCardNumber)
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
    func testSampleBuilderItemMacro_companyName_category_and_string_property() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .companyName)
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
    func testSampleBuilderItemMacro_username_category_and_string_property() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .username)
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
    func testSampleBuilderItemMacro_url_category_and_string_property() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .url)
                let item2: String
            }
            """,
            expandedSource: """
            struct Example {
                let item1: Int
                let item2: String
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "'url' category is not compatible with 'String' type. Use 'URL' type instead.", line: 4, column: 5)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderItemMacro_image_category_and_string_property() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .image(width: 200, height: 300))
                let item2: String
            }
            """,
            expandedSource: """
            struct Example {
                let item1: Int
                let item2: String
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "'image(width:200,height:300)' category is not compatible with 'String' type. Use 'URL' type instead.", line: 4, column: 5)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderItemMacro_price_category_and_string_property() throws {
        #if canImport(Macros)
        assertMacroExpansion(
            """
            struct Example {
                let item1: Int
            
                @SampleBuilderItem(category: .price)
                let item2: String
            }
            """,
            expandedSource: """
            struct Example {
                let item1: Int
                let item2: String
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "'price' category is not compatible with 'String' type. Use 'Double' type instead.", line: 4, column: 5)
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    func testSampleBuilderItemMacro_email_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .email)
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'email' category is not compatible with 'URL' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_firstName_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .firstName)
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'firstName' category is not compatible with 'URL' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_lastName_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .lastName)
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'lastName' category is not compatible with 'URL' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_fullName_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .fullName)
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'fullName' category is not compatible with 'URL' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_address_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .address)
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'address' category is not compatible with 'URL' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_appVersion_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .appVersion)
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'appVersion' category is not compatible with 'URL' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_creditCardNumber_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .creditCardNumber)
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'creditCardNumber' category is not compatible with 'URL' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_companyName_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .companyName)
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'companyName' category is not compatible with 'URL' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_username_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .username)
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'username' category is not compatible with 'URL' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_url_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .url)
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_image_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .image(width: 200, height: 300))
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_price_category_and_URL_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .price)
                    let item2: URL
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: URL
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'price' category is not compatible with 'URL' type. Use 'Double' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
    func testSampleBuilderItemMacro_email_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .email)
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'email' category is not compatible with 'Double' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_firstName_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .firstName)
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'firstName' category is not compatible with 'Double' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_lastName_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .lastName)
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'lastName' category is not compatible with 'Double' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_fullName_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .fullName)
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'fullName' category is not compatible with 'Double' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_address_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .address)
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'address' category is not compatible with 'Double' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_appVersion_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .appVersion)
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'appVersion' category is not compatible with 'Double' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_creditCardNumber_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .creditCardNumber)
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'creditCardNumber' category is not compatible with 'Double' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_companyName_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .companyName)
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'companyName' category is not compatible with 'Double' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_username_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .username)
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'username' category is not compatible with 'Double' type. Use 'String' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_Double_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .url)
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'url' category is not compatible with 'Double' type. Use 'URL' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_image_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .image(width: 200, height: 300))
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                diagnostics: [
                    DiagnosticSpec(message: "'image(width:200,height:300)' category is not compatible with 'Double' type. Use 'URL' type instead.", line: 4, column: 5)
                ],
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
        func testSampleBuilderItemMacro_price_category_and_Double_property() throws {
            #if canImport(Macros)
            assertMacroExpansion(
                """
                struct Example {
                    let item1: Int
                
                    @SampleBuilderItem(category: .price)
                    let item2: Double
                }
                """,
                expandedSource: """
                struct Example {
                    let item1: Int
                    let item2: Double
                }
                """,
                macros: testMacros
            )
            #else
            throw XCTSkip("macros are only supported when running tests for the host platform")
            #endif
        }
}

