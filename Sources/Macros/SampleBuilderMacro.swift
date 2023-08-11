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

        var sampleCode = """
        
        static var sample: [Self] {
            [

        """
        
        for _ in 1...numberOfItems {
            
            var parameterList = ""
            
            for member in structDecl.memberBlock.members {
                guard let variableDecl = member.decl.as(VariableDeclSyntax.self),
                      let identifierDecl = variableDecl.bindings.first?.pattern.as(IdentifierPatternSyntax.self),
                      let identifierType = variableDecl.bindings.first?.typeAnnotation?.type.as(SimpleTypeIdentifierSyntax.self)?.name
                else {
                    fatalError("Compiler Bug")
                }
                
                do {
                    parameterList += try getParameterItem(
                        identifierName: identifierDecl.identifier,
                        identifierType: identifierType,
                        isLast: member == structDecl.memberBlock.members.last
                    )
                } catch {
                    throw error
                }
            }
            
            sampleCode += """
                .init(\(parameterList)),
            
            """
        }
        
        sampleCode += """
            ]
        }
        """
        
        return [DeclSyntax(stringLiteral: sampleCode)]
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
    
    static func getParameterItem(
        identifierName: TokenSyntax,
        identifierType: TokenSyntax,
        isLast: Bool
    ) throws -> String {
        
        var parameterItem = ""
        if let supportedType = SupportedType(rawValue: identifierType.text) {
            parameterItem = "\(identifierName.text): \(supportedType.default)"
        } else {
            parameterItem = "\(identifierName.text): \(identifierType.text).sample.first!"
        }
        
        if !isLast {
            parameterItem += ", "
        }
        
        return parameterItem
    }
}

enum SampleBuilderError: Error, CustomStringConvertible {
    case notAnStruct
    case argumentNotGreaterThanZero
    case typeNotSupported
    
    var description: String {
        switch self {
        case .notAnStruct:
            return "This macro can only be applied to structs"
        case .argumentNotGreaterThanZero:
            return "Argument is not greater than zero"
        case .typeNotSupported:
            return "Type is not supported"
        }
    }
}

enum SupportedType: String {
    case int = "Int"
    case int8 = "Int8"
    case int16 = "Int16"
    case int32 = "Int32"
    case int64 = "Int64"
    case uInt8 = "UInt8"
    case uInt16 = "UInt16"
    case uInt32 = "UInt32"
    case uInt64 = "UInt64"
    case float = "Float"
    case double = "Double"
    case string = "String"
    case bool = "Bool"
    case data = "Data"
    case date = "Date"
    case uuid = "UUID"
    case cgPoint = "CGPoint"
    case cgRect = "CGRect"
    case cgSize = "CGSize"
    case cgVector = "CGVector"
    case cgFloat = "CGFloat"
    case url = "URL"
    
    var `default`: String {
        switch self {
        case .int, .int8, .int16, .int32, .int64, .uInt8, .uInt16, .uInt32, .uInt64, .double, .float, .cgFloat:
            "0"
        case .string:
            #""Hello World""#
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
