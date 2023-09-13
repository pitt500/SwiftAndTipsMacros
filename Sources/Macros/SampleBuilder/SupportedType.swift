//
//  SupportedType.swift
//  
//
//  Created by Pedro Rojas on 15/08/23.
//

import SwiftSyntax
import DataGenerator
import DataCategory


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

    func exprSyntax(
        dataGeneratorType: DataGeneratorType,
        category: DataCategory?
    ) -> ExprSyntax {
        switch dataGeneratorType {
        case .default:
            return ExprSyntax(stringLiteral: "DataGenerator.\(dataGeneratorType).\(self.rawValue.lowercased())()")
        case .random:
            let categoryParameter = if let category = category {
                "dataCategory: .init(rawValue: \"\(category.rawValue)\")"
            } else { "" }
            
            return ExprSyntax(stringLiteral: "DataGenerator.\(dataGeneratorType)(\(categoryParameter)).\(self.rawValue.lowercased())()")
        }
    }
}

