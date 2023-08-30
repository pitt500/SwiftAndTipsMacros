//
//  PrimitiveType.swift
//  
//
//  Created by Pedro Rojas on 15/08/23.
//

import SwiftSyntax
import DataGenerator


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

    func exprSyntax(dataGeneratorType: DataGeneratorType) -> ExprSyntax {
        let generator = switch dataGeneratorType {
        case .default:
            DataGenerator.default
        case .random:
            DataGenerator.random
        }
        
        return switch self {
        case .int:
            ExprSyntax(stringLiteral: "\(generator.int())")
        case .int8:
            ExprSyntax(stringLiteral: "\(generator.int8())")
        case .int16:
            ExprSyntax(stringLiteral: "\(generator.int16())")
        case .int32:
            ExprSyntax(stringLiteral: "\(generator.int32())")
        case .int64:
            ExprSyntax(stringLiteral: "\(generator.int64())")
        case .uInt8:
            ExprSyntax(stringLiteral: "\(generator.uint8())")
        case .uInt16:
            ExprSyntax(stringLiteral: "\(generator.uint16())")
        case .uInt32:
            ExprSyntax(stringLiteral: "\(generator.uint32())")
        case .uInt64:
            ExprSyntax(stringLiteral: "\(generator.uint64())")
        case .float:
            ExprSyntax(stringLiteral: "\(generator.float())")
        case .double:
            ExprSyntax(stringLiteral: "\(generator.double())")
        case .string:
            ExprSyntax(stringLiteral: "\"\(generator.string())\"")
        case .bool:
            ExprSyntax(stringLiteral: "\(generator.bool())")
        case .data, .date, .uuid, .cgPoint, .cgRect, .cgSize, .cgVector, .cgFloat, .url:
            ExprSyntax(stringLiteral: "DataGenerator.\(dataGeneratorType).\(self.rawValue.lowercased())()")
        }
    }
}

