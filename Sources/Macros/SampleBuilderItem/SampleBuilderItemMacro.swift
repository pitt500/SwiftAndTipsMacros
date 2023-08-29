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
        // Verify that we are using the macro in a stored property
        // Verify that category is matching variable type, else throw an error.
        
        // It does nothing, but will help SampleBuilder to support categories
        return []
    }
    
    static func getDataCategory(from node: AttributeSyntax) -> DataCategory {
        guard let argumentTuple = node.argument?.as(TupleExprElementListSyntax.self)?.first,
              let categoryString = argumentTuple
            .expression
            .as(MemberAccessExprSyntax.self)?
            .name.text,
              let dataCategory = DataCategory(rawValue: categoryString)
        else {
            fatalError("Compiler bug: Argument must exist")
        }
        
        return dataCategory
    }
}
