//
//  SampleBuilderError.swift
//  
//
//  Created by Pedro Rojas on 15/08/23.
//

import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

enum SampleBuilderDiagnostic: String, DiagnosticMessage {
    case notAnStructOrEnum
    case argumentNotGreaterThanZero
    case enumWithEmptyCases
    case sampleBuilderItemRedundant
    
    var severity: DiagnosticSeverity {
        switch self {
        case .notAnStructOrEnum:
            return .error
        case .argumentNotGreaterThanZero:
            return .error
        case .enumWithEmptyCases:
            return .error
        case .sampleBuilderItemRedundant:
            return .warning
        }
    }
    
    var message: String {
        switch self {
        case .notAnStructOrEnum:
            return "@SampleBuilder can only be applied to Structs and Enums"
        case .argumentNotGreaterThanZero:
            return "'numberOfitems' argument must be greater than zero"
        case .enumWithEmptyCases:
            return "Enum must contain at least one case"
        case .sampleBuilderItemRedundant:
            return "@SampleBuilderItem attribute has no effect when generator type is 'default'"
        }
    }
    
    var diagnosticID: MessageID {
        return MessageID(domain: "SwiftAndTipsMacros", id: rawValue)
    }
    
    static func report(
        diagnostic: Self,
        node: Syntax,
        context: some SwiftSyntaxMacros.MacroExpansionContext
    ) {
        
        let fixIts = getFixIts(for: diagnostic, node: node)
        let diagnostic = Diagnostic(
            node: Syntax(node),
            message: diagnostic,
            fixIts: fixIts
        )
        context.diagnose(diagnostic)
    }
    
    static func getFixIts(
        for diagnostic: Self,
        node: Syntax
    ) -> [FixIt] {
        switch diagnostic {
        case .enumWithEmptyCases:
            return [
                .init(
                    message: SampleBuilderFixIt.addNewEnumCase,
                    changes: [
                        .replace(
                            oldNode: Syntax(
                                fromProtocol: node.as(EnumDeclSyntax.self)?.memberBlock ?? node
                            ),
                            newNode: Syntax(
                                MemberDeclBlockSyntax(
                                    leftBrace: .leftBraceToken(),
                                    members: MemberDeclListSyntax {
                                        MemberDeclListItemSyntax(
                                            decl: EnumCaseDeclSyntax(
                                                leadingTrivia: .newline,
                                                caseKeyword: .keyword(.case),
                                                elements: EnumCaseElementListSyntax {
                                                    EnumCaseElementSyntax(
                                                        leadingTrivia: .space,
                                                        identifier: .identifier("<#your case#>")
                                                    )
                                                },
                                                trailingTrivia: .newline
                                            )
                                        )
                                    },
                                    rightBrace: .rightBraceToken()
                                )
                            )
                        )
                    ]
                )
            ]
        case .sampleBuilderItemRedundant:
            return [
                .init(
                    message: SampleBuilderFixIt.removeSampleBuilderItem,
                    changes: [
                        .replace(
                            oldNode: Syntax(
                                fromProtocol: node.as(AttributeSyntax.self) ?? node
                            ),
                            newNode: Syntax(AttributeSyntax(stringLiteral: ""))
                        )
                    ]
                )
            ]
        case .argumentNotGreaterThanZero, .notAnStructOrEnum:
            return [] // No suggestion to provide
        }
    }
    
}
