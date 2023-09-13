//
//  DataCategory.swift
//
//
//  Created by Pedro Rojas on 29/08/23.
//

import Foundation

public struct DataCategory: RawRepresentable {
    
    public enum BuiltInValue: String {
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
    
    public enum Category {
        case builtInValue(BuiltInValue)
        case image(width: Int, height: Int)
    }
    
    public var category: Category
    
    public init(_ value: BuiltInValue) {
        self.category = .builtInValue(value)
    }
    
    public init(imageWidth width: Int, height: Int) {
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
        let rawValue = rawValue.replacingOccurrences(of: " ", with: "")
        if let value = BuiltInValue(rawValue: rawValue) {
            category = .builtInValue(value)
            return
        }
        
        if rawValue.hasPrefix("image") {
            let (width, height) = DataCategory.getImageWidthAndHeight(from: rawValue)
            category = .image(width: width, height: height)
            return
        }
        
        return nil
    }
    
    public enum SupportedType: String {
        case string
        case url
        case double
        
        public var title: String {
            switch self {
            case .string:
                "String"
            case .url:
                "URL"
            case .double:
                "Double"
            }
        }
    }
    
    public func getSupportedType() -> SupportedType {
        switch self.category {
        case .builtInValue(let value):
            switch value {
            case .firstName, .lastName, .fullName, .email, .address, .appVersion, .creditCardNumber, .companyName, .username:
                return .string
            case .price:
                return .double
            case .url:
                return .url
            }
        case .image:
            return .url
        }
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
    
    static private func getImageWidthAndHeight(from inputString: String) -> (Int, Int) {

        // 1. Create a regular expression pattern
        let pattern = "image\\(width:(\\d+),height:(\\d+)\\)"
        
        // 2. Match the string against the pattern
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []),
              let match = regex.firstMatch(in: inputString, options: [], range: NSRange(location: 0, length: inputString.utf16.count)),
              
                // 3. Extract the values
              let widthRange = Range(match.range(at: 1), in: inputString),
              let heightRange = Range(match.range(at: 2), in: inputString),
              let width = Int(inputString[widthRange]),
              let height = Int(inputString[heightRange])
        else {
            print("No match found for '\(inputString)'. Please report this issue!")
            return (100, 100) // Default in case of any issue
        }
        
        return (width, height)
    }
}

