//
//  PrimitiveType.swift
//  
//
//  Created by Pedro Rojas on 15/08/23.
//

import SwiftSyntax
import DataGenerator
import DataCategory


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

    func exprSyntax(
        dataGeneratorType: DataGeneratorType,
        category: DataCategory?
    ) -> ExprSyntax {
        let generator = switch dataGeneratorType {
        case .default:
            DataGenerator.default
        case .random:
            DataGenerator.random(dataCategory: category)
        }
        
        switch self {
        case .int:
            return ExprSyntax(stringLiteral: "\(generator.int())")
        case .int8:
            return ExprSyntax(stringLiteral: "\(generator.int8())")
        case .int16:
            return ExprSyntax(stringLiteral: "\(generator.int16())")
        case .int32:
            return ExprSyntax(stringLiteral: "\(generator.int32())")
        case .int64:
            return ExprSyntax(stringLiteral: "\(generator.int64())")
        case .uInt8:
            return ExprSyntax(stringLiteral: "\(generator.uint8())")
        case .uInt16:
            return ExprSyntax(stringLiteral: "\(generator.uint16())")
        case .uInt32:
            return ExprSyntax(stringLiteral: "\(generator.uint32())")
        case .uInt64:
            return ExprSyntax(stringLiteral: "\(generator.uint64())")
        case .float:
            return ExprSyntax(stringLiteral: "\(generator.float())")
        case .double:
            return ExprSyntax(stringLiteral: "\(generator.double())")
//        case .string:
//            return ExprSyntax(stringLiteral: "\"\(generator.string())\"")
            #warning("Investigate why an explicit string is not making macro be compiled")
        case .bool:
            return ExprSyntax(stringLiteral: "\(generator.bool())")
        case .data, .date, .uuid, .cgPoint, .cgRect, .cgSize, .cgVector, .cgFloat, .url, .string:
            let categoryParameter = if let category { "dataCategory: .init(rawValue: \"\(category.rawValue)\")" } else { "" }
            return ExprSyntax(stringLiteral: "DataGenerator.\(dataGeneratorType)(\(categoryParameter)).\(self.rawValue.lowercased())()")
        }
    }
}

