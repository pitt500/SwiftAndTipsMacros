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
        
        let numberOfItems = getNumberOfItems(from: node)

        if numberOfItems <= 0 {
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
                
                let supportedType = SupportedType(rawValue: identifierType.text)
                
                if supportedType == .int {
                    parameterList += "\(identifier.text): \(intCounter)"
                } else if supportedType == .string {
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
    
    static func getNumberOfItems(from node: SwiftSyntax.AttributeSyntax) -> Int {
        guard let argumentTuple = node.argument?.as(TupleExprElementListSyntax.self)?.first,
              let integerExpression = argumentTuple.expression.as(IntegerLiteralExprSyntax.self),
              let numberOfItems = Int(integerExpression.digits.text)
        else {
            fatalError("Compiler bug: Argument must exist")
        }
        
        return numberOfItems
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

enum SupportedType: String {
    case int = "Int"
    case int8
    case int16
    case int32
    case int64
    case uInt8
    case uInt16
    case uInt32
    case uInt64
    case float
    case double
    case string = "String"
    case bool
    case data
    case date
    case uuid
    case cgPoint
    case cgRect
    case cgSize
    case cgVector
    case cgFloat
    case url
    
    var `default`: String {
        switch self {
        case .int, .int8, .int16, .int32, .int64, .uInt8, .uInt16, .uInt32, .uInt64, .double, .float, .cgFloat:
            "0"
        case .string:
            "Hello World"
        case .bool:
            "true"
        case .data:
            "Data()"
        case .date:
            "Date()"
        case .uuid:
            "UUID()"
        case .cgPoint:
            "CGPoint()"
        case .cgRect:
            "CGRect()"
        case .cgSize:
            "CGSize()"
        case .cgVector:
            "CGVector()"
        case .url:
            #"URL(string: "https://www.apple.com")!"#
        }
    }
}
