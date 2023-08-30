//
//  VariableDeclSyntax+Extension.swift
//  
//
//  Created by Pedro Rojas on 15/08/23.
//

import SwiftSyntax

extension VariableDeclSyntax {
    var isStoredProperty: Bool {
        // Stored properties cannot have more than 1 binding in its declaration.
        guard bindings.count == 1
        else {
            return false
        }
        
        guard let accesor = bindings.first?.accessor
        else {
            // Nothing to review. It's a valid stored property
            return true
        }
        
        switch accesor {
        case .accessors(let accesorBlockSyntax):
            // Observers are valid accesors only
            let validAccesors = Set<TokenKind>([
                .keyword(.willSet), .keyword(.didSet)
            ])
            
            let hasValidAccesors = accesorBlockSyntax.accessors.contains {
                // Other kind of accesors will make the variable a computed property
                validAccesors.contains($0.accessorKind.tokenKind)
            }
            return hasValidAccesors
        case .getter:
            // A variable with only a getter is not valid for initialization.
            return false
        }
        
    }
    
    var isPublic: Bool {
        modifiers?.contains {
            $0.name.tokenKind == .keyword(.public)
        } ?? false
    }
    
    var isPrivate: Bool {
        modifiers?.contains {
            $0.name.tokenKind == .keyword(.private)
        } ?? false
    }
    
    var typeName: String {
        self.bindings.first?.typeAnnotation?.type.as(SimpleTypeIdentifierSyntax.self)?.name.text ?? ""
    }
}
