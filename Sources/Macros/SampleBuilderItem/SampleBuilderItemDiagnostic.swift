/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

//
//  SampleBuilderItemDiagnostic.swift
//
//
//  Created by Pedro Rojas on 29/08/23.
//

import SwiftSyntax
import SwiftDiagnostics
import SwiftSyntaxMacros
import DataCategory

enum SampleBuilderItemDiagnostic: DiagnosticMessage {
    case notAStoredProperty
    case categoryNotSupported(category: DataCategory, typeName: String)
    
    var severity: DiagnosticSeverity {
        switch self {
        case .notAStoredProperty:
            return .error
        case .categoryNotSupported:
            return .error
        }
    }
    
    var message: String {
        switch self {
        case .notAStoredProperty:
            return "@SampleBuilderItem can only be applied to stored properties in structs"
        case .categoryNotSupported(category: let category, typeName: let typeName):
            return "'\(category.rawValue)' category is not compatible with '\(typeName)' type. Use '\(category.getSupportedType().title)' type instead."
        }
    }
    
    var id: String {
        switch self {
        case .notAStoredProperty:
            return "notAStoredProperty"
        case .categoryNotSupported:
            return "categoryNotSupported"
        }
    }
    
    var diagnosticID: MessageID {
        return MessageID(domain: "SwiftAndTipsMacros", id: id)
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
