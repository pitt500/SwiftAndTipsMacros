//
//  SampleBuilderItemDiagnostic.swift
//
//
//  Created by Pedro Rojas on 29/08/23.
//

import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros

enum SampleBuilderItemDiagnostic: String, DiagnosticMessage {
    case notAStoredProperty
    
    var severity: DiagnosticSeverity {
        switch self {
        case .notAStoredProperty:
            return .error
        }
    }
    
    var message: String {
        switch self {
        case .notAStoredProperty:
            return "@SampleBuilderItem can only be applied to stored properties in structs"
        }
    }
    
    var diagnosticID: MessageID {
        return MessageID(domain: "SwiftAndTipsMacros", id: rawValue)
    }
    
    static func report(
        diagnostic: Self,
        node: AttributeSyntax,
        context: some SwiftSyntaxMacros.MacroExpansionContext
    ) {
        let diagnostic = Diagnostic(
            node: Syntax(node),
            message: diagnostic
        )
        context.diagnose(diagnostic)
    }
}
