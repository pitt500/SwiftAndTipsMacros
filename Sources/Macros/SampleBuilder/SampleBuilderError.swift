//
//  SampleBuilderError.swift
//  
//
//  Created by Pedro Rojas on 15/08/23.
//

import Foundation

enum SampleBuilderError: Error, CustomStringConvertible {
    case notAnStruct
    case argumentNotGreaterThanZero
    case typeNotSupported(typeName: String)
    
    var description: String {
        switch self {
        case .notAnStruct:
            return "This macro can only be applied to structs"
        case .argumentNotGreaterThanZero:
            return "Argument is not greater than zero"
        case .typeNotSupported(let typeName):
            return "\(typeName) is not supported"
        }
    }
}
