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
    
    var parameterTypes: [TypeSyntax] {
        self.elements.first?.associatedValue?.parameterList.map(\.type) ?? []
    }
}
