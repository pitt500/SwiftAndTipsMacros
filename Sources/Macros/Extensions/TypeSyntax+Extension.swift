/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

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
        self.as(IdentifierTypeSyntax.self) != nil
    }
    
    var isDictionary: Bool {
        self.as(DictionaryTypeSyntax.self) != nil
    }
    
    var isOptional: Bool {
        self.as(OptionalTypeSyntax.self) != nil
    }
}
