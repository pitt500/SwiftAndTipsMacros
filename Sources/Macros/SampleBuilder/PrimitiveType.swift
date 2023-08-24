//
//  PrimitiveType.swift
//  
//
//  Created by Pedro Rojas on 15/08/23.
//

import SwiftSyntax


enum PrimitiveType: String {
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
    
    var exprSyntax: ExprSyntax {
        switch self {
        case .int, .int8, .int16, .int32, .int64, .uInt8, .uInt16, .uInt32, .uInt64, .double, .float, .cgFloat:
            ExprSyntax(
                IntegerLiteralExprSyntax(
                    digits: .integerLiteral("0")
                )
            )
        case .string:
            ExprSyntax(
                StringLiteralExprSyntax(content: "Hello World")
            )
        case .bool:
            ExprSyntax(
                BooleanLiteralExprSyntax(booleanLiteral: true)
            )
        case .data:
            ExprSyntax(stringLiteral: "Data()")
        case .date:
            ExprSyntax(stringLiteral: "Date()")
        case .uuid:
            ExprSyntax(stringLiteral: "UUID()")
        case .cgPoint:
            ExprSyntax(stringLiteral: "CGPoint()")
        case .cgRect:
            ExprSyntax(stringLiteral: "CGRect()")
        case .cgSize:
            ExprSyntax(stringLiteral: "CGSize()")
        case .cgVector:
            ExprSyntax(stringLiteral: "CGVector()")
        case .url:
            ExprSyntax(
                stringLiteral: #"URL(string: "https://www.apple.com")!"#
            )
        }
    }
}
