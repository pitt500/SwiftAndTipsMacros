//
//  InitParameterItem.swift
//  
//
//  Created by Pedro Rojas on 16/08/23.
//

import SwiftSyntax

struct ParameterItem {
    let identifierName: String?
    let identifierType: TypeSyntax
    
    var hasName: Bool {
        identifierName != nil
    }
}
