//
//  DataCategory.swift
//
//
//  Created by Pedro Rojas on 29/08/23.
//

import Foundation

public struct DataCategory: RawRepresentable {
    
    enum BuiltInValue: String {
        // String
        case firstName
        case lastName
        case fullName
        case email
        case address
        case appVersion
        case creditCardNumber
        case companyName
        case username
        
        //Double
        case price
        case url
    }
    
    enum Category {
        case builtInValue(BuiltInValue)
        case image(width: Int, height: Int)
    }
    
    var category: Category
    
    init(_ value: BuiltInValue) {
        self.category = .builtInValue(value)
    }
    
    init(imageWidth width: Int, height: Int) {
        category = .image(width: width, height: height)
    }
    
    public var rawValue: String {
        switch category {
        case .builtInValue(let value):
            return value.rawValue
        case .image(let width, let height):
            return "image:\(width),\(height)"
        }
    }
    
    public init?(rawValue: String) {
        if let value = BuiltInValue(rawValue: rawValue) {
            category = .builtInValue(value)
            return
        }
        
        if rawValue.hasPrefix("image") {
            let width = 200
            let height = 300
            category = .image(width: width, height: height)
            return
        }
        
        return nil
    }
}

