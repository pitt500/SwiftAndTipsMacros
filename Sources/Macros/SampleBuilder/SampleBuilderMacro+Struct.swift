/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

//
//  SampleBuilderMacro+Struct.swift
//  
//
//  Created by Pedro Rojas on 19/08/23.
//

import SwiftSyntax
import DataGenerator
import DataCategory
import SwiftSyntaxMacros

extension SampleBuilderMacro {
    static func SampleBuilderMacroForStruct(
        structDecl: StructDeclSyntax,
        numberOfItems: Int,
        generatorType: DataGeneratorType,
        context: MacroExpansionContext
    ) -> [SwiftSyntax.DeclSyntax] {
        let validParameters = getValidParameterList(
            from: structDecl.memberBlock,
            generatorType: generatorType,
            context: context
        )
        
        let sampleCode = generateSampleCodeSyntax(
            sampleData: generateSampleData(
                parameters: validParameters,
                numberOfItems: numberOfItems,
                generatorType: generatorType
            )
        )
        
        return [DeclSyntax(sampleCode)]
    }
    
    static func getValidParameterList(
        from structDecl: StructDeclSyntax,
        generatorType: DataGeneratorType,
        context: MacroExpansionContext
    ) -> [ParameterItem] {
        getValidParameterList(from: structDecl.memberBlock,
                              generatorType: generatorType,
                              context: context)
    }
    
}
