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
        print(declaration.as(VariableDeclSyntax.self)!)
        
        // Get Category String
        // Verify that we are using the macro in a stored property
        // Verify that category is matching variable type, else throw an error.
        
        // It does nothing, but will help SampleBuilder to support categories
        return []
    }
    

}

// Get category string

/*
 AttributeSyntax
 ├─atSignToken: atSign
 ├─attributeName: SimpleTypeIdentifierSyntax
 │ ╰─name: identifier("SampleBuilderItem")
 ├─leftParen: leftParen
 ├─argument: TupleExprElementListSyntax
 │ ╰─[0]: TupleExprElementSyntax
 │   ├─label: identifier("category")
 │   ├─colon: colon
 │   ╰─expression: MemberAccessExprSyntax
 │     ├─dot: period
 │     ╰─name: identifier("email")
 ╰─rightParen: rightParen
 */
