//
//  SampleBuilderMacro.swift
//  
//
//  Created by Pedro Rojas on 05/08/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SampleBuilderMacro: MemberMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw SampleBuilderError.notAnStruct
        }
        
        guard let numberOfItems = Int(structDecl.attributes?
            .first?.as(AttributeSyntax.self)?
            .argument?.as(TupleExprElementListSyntax.self)?
            .first?.expression.as(IntegerLiteralExprSyntax.self)?
            .digits.text ?? "")
        else {
            fatalError("Compiler bug: Argument must exist")
        }
        
        guard numberOfItems > 0
        else {
            throw SampleBuilderError.argumentNotGreaterThanZero
        }

        var finalString = """
        
        static var sample: [Self] {
            [

        """
        
        for intCounter in 1...numberOfItems {
            
            var parameterList = ""
            
            for (index, member) in structDecl.memberBlock.members.enumerated() {
                guard let variableDecl = member.decl.as(VariableDeclSyntax.self),
                      let identifierDecl = variableDecl.bindings.first?.pattern.as(IdentifierPatternSyntax.self),
                      let identifierType = variableDecl.bindings.first?.typeAnnotation?.type.as(SimpleTypeIdentifierSyntax.self)?.name
                else {
                    fatalError("Compiler Bug")
                }
                
                let identifier = identifierDecl.identifier
                
                if identifierType.text == "Int" {
                    parameterList += "\(identifier.text): \(intCounter)"
                } else if identifierType.text == "String" {
                    parameterList += "\(identifier.text): \"Hello\""
                }
                
                if index != structDecl.memberBlock.members.count - 1 {
                    parameterList += ", "
                }
            }
            
            finalString += """
                .init(\(parameterList)),
            
            """
            
        }
        
        finalString += """
            ]
        }
        """
        
        return [DeclSyntax(stringLiteral: finalString)]
    }
}

enum SampleBuilderError: Error, CustomStringConvertible {
    case notAnStruct
    case argumentNotGreaterThanZero
    
    var description: String {
        switch self {
        case .notAnStruct:
            return "This macro can only be applied to structs"
        case .argumentNotGreaterThanZero:
            return "Argument is not greater than zero"
        }
    }
}
