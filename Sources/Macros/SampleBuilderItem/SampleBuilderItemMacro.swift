//
//  File.swift
//  
//
//  Created by Pedro Rojas on 23/08/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics
import DataCategory

public struct SampleBuilderItemMacro: PeerMacro {
    /*
     Why is this a peer macro? TL;DR: Temporary issue in Xcode beta 6 and 7
     
     Read this post for more context:
     https://forums.swift.org/t/member-macro-cannot-be-attached-to-property/66670/2
     */
    
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingPeersOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        let dataCategory = getDataCategory(from: node)

        guard let variableDecl = declaration
            .as(VariableDeclSyntax.self),
              variableDecl.isStoredProperty
        else {
            SampleBuilderItemDiagnostic.report(
                diagnostic: .notAStoredProperty,
                node: node,
                context: context
            )
            return []
        }
        
        guard dataCategory.supports(type: variableDecl.typeName)
        else {
            SampleBuilderItemDiagnostic.report(
                diagnostic: .categoryNotSupported(category: dataCategory, typeName: variableDecl.typeName),
                node: node,
                context: context
            )
            return []
        }
        
        // It does nothing, but will help SampleBuilder to support categories
        return []
    }
    
    static func getDataCategory(from node: AttributeSyntax) -> DataCategory {
        guard let argumentTuple = node.argument?.as(TupleExprElementListSyntax.self)?.first
        else {
            fatalError("Compiler bug: Argument must exist")
        }
        
        if let simpleCategoryString = argumentTuple
            .expression
            .as(MemberAccessExprSyntax.self)?
            .name.text,
           let dataCategory = DataCategory(rawValue: simpleCategoryString) {
            
            return dataCategory
        } else if let imageCategoryString = argumentTuple
            .expression
            .as(FunctionCallExprSyntax.self)?
            .description
            .dropFirst(), // it removes the dot from .image(...)
                  let dataCategory = DataCategory(rawValue: String(imageCategoryString)) {
            
            return dataCategory
        }
        
        fatalError("Compiler bug: Argument must exist")
    }
}
