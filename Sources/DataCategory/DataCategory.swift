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
            return "image(width:\(width),height:\(height))"
        }
    }
    
    public init?(rawValue: String) {
        if let value = BuiltInValue(rawValue: rawValue) {
            category = .builtInValue(value)
            return
        }
        
        #warning("Get image parameters")
        if rawValue.hasPrefix("image") {
            let width = 200
            let height = 300
            category = .image(width: width, height: height)
            return
        }
        
        return nil
    }
    
    enum SupportedType: String {
        case string
        case url
        case double
    }
    
    public func supports(type: String) -> Bool {
        guard let supportedType = SupportedType(rawValue: type.lowercased())
        else {
            return false
        }

        switch supportedType {
        case .string:
            let stringCategories: Set<BuiltInValue> = [
                .firstName, .lastName, .fullName, .email,
                .address, .appVersion, .creditCardNumber, .companyName, .username
            ]
            
            guard case .builtInValue(let value) = category
            else {
                return false
            }
            
            return stringCategories.contains(value)
        case .url:
            if case .image(_,_) = category {
                return true
            }
            
            if case .builtInValue(let value) = category {
                return value == .url
            }
            
            return false
        case .double:
            guard case .builtInValue(let value) = category
            else {
                return false
            }
            
            return value == .price
        }
    }
}

