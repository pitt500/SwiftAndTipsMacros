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
            ExprSyntax(
                FunctionCallExprSyntax(
                    calledExpression: IdentifierExprSyntax(identifier: .identifier("Data")),
                    leftParen: .leftParenToken(),
                    argumentList: TupleExprElementListSyntax(),
                    rightParen: .rightParenToken()
                )
            )
        case .date:
            ExprSyntax(
                FunctionCallExprSyntax(
                    calledExpression: IdentifierExprSyntax(identifier: .identifier("Date")),
                    leftParen: .leftParenToken(),
                    argumentList: TupleExprElementListSyntax(),
                    rightParen: .rightParenToken()
                )
            )
        case .uuid:
            ExprSyntax(
                FunctionCallExprSyntax(
                    calledExpression: IdentifierExprSyntax(identifier: .identifier("UUID")),
                    leftParen: .leftParenToken(),
                    argumentList: TupleExprElementListSyntax(),
                    rightParen: .rightParenToken()
                )
            )
        case .cgPoint:
            ExprSyntax(
                FunctionCallExprSyntax(
                    calledExpression: IdentifierExprSyntax(identifier: .identifier("CGPoint")),
                    leftParen: .leftParenToken(),
                    argumentList: TupleExprElementListSyntax(),
                    rightParen: .rightParenToken()
                )
            )
        case .cgRect:
            ExprSyntax(
                FunctionCallExprSyntax(
                    calledExpression: IdentifierExprSyntax(identifier: .identifier("CGRect")),
                    leftParen: .leftParenToken(),
                    argumentList: TupleExprElementListSyntax(),
                    rightParen: .rightParenToken()
                )
            )
        case .cgSize:
            ExprSyntax(
                FunctionCallExprSyntax(
                    calledExpression: IdentifierExprSyntax(identifier: .identifier("CGSize")),
                    leftParen: .leftParenToken(),
                    argumentList: TupleExprElementListSyntax(),
                    rightParen: .rightParenToken()
                )
            )
        case .cgVector:
            ExprSyntax(
                FunctionCallExprSyntax(
                    calledExpression: IdentifierExprSyntax(identifier: .identifier("CGVector")),
                    leftParen: .leftParenToken(),
                    argumentList: TupleExprElementListSyntax(),
                    rightParen: .rightParenToken()
                )
            )
        case .url:
            ExprSyntax(
                ForcedValueExprSyntax(
                    expression: FunctionCallExprSyntax(
                        calledExpression: IdentifierExprSyntax(identifier: .identifier("URL")),
                        leftParen: .leftParenToken(),
                        argumentList: TupleExprElementListSyntax {
                            TupleExprElementSyntax(
                                label: "string",
                                expression: StringLiteralExprSyntax(
                                    content: "https://www.apple.com"
                                )
                            )
                        },
                        rightParen: .rightParenToken()
                    ),
                    exclamationMark: .exclamationMarkToken()
                )
            )
        }
    }
}
