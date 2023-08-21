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
    
    var severity: DiagnosticSeverity {
        switch self {
        case .notAnStructOrEnum:
            return .error
        case .argumentNotGreaterThanZero:
            return .error
        case .enumWithEmptyCases:
            return .error
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
        let error = Diagnostic(
            node: Syntax(node),
            message: diagnostic
        )
        context.diagnose(error)
    }
    
}
