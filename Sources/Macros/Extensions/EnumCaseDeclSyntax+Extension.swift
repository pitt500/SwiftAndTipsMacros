/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

//
//  EnumCaseDeclSyntax+Extension.swift
//  
//
//  Created by Pedro Rojas on 18/08/23.
//

import SwiftSyntax

extension EnumCaseDeclSyntax {
    var hasAssociatedValues: Bool {
        self.elements.first?.parameterClause != nil
    }
    
    var name: String {
        guard let caseName = self.elements.first?.name.text
        else {
            fatalError("Compiler Bug: Case name not found")
        }
        
        return caseName
    }
    
    var parameters: [(TokenSyntax?, TypeSyntax)] {
        self.elements.first?.parameterClause?.parameters.map {
            ($0.firstName, $0.type)
        } ?? []
    }
}
