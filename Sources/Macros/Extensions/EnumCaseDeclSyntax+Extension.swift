//
//  EnumCaseDeclSyntax+Extension.swift
//  
//
//  Created by Pedro Rojas on 18/08/23.
//

import SwiftSyntax

extension EnumCaseDeclSyntax {
    var hasAssociatedValues: Bool {
        self.elements.first?.associatedValue != nil
    }
    
    var name: String {
        guard let caseName = self.elements.first?.identifier.text
        else {
            fatalError("Compiler Bug: Case name not found")
        }
        
        return caseName
    }
    
    var parameters: [(TokenSyntax?, TypeSyntax)] {
        self.elements.first?.associatedValue?.parameterList.map {
            ($0.firstName, $0.type)
        } ?? []
    }
}
