//
//  InitParameterItem.swift
//  
//
//  Created by Pedro Rojas on 16/08/23.
//

import SwiftSyntax
import DataGenerator
import DataCategory

struct ParameterItem {
    let identifierName: String?
    let identifierType: TypeSyntax
    let category: DataCategory?
    
    var hasName: Bool {
        identifierName != nil
    }
}
