//
//  TypeSyntax+Extension.swift
//  
//
//  Created by Pedro Rojas on 15/08/23.
//

import SwiftSyntax

extension TypeSyntax {
    var isArray: Bool {
        self.as(ArrayTypeSyntax.self) != nil
    }
    
    var isSimpleType: Bool {
        self.as(SimpleTypeIdentifierSyntax.self) != nil
    }
    
    var isDictionary: Bool {
        self.as(DictionaryTypeSyntax.self) != nil
    }
}
