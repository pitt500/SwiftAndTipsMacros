/*
 This source file is part of SwiftAndTipsMacros
 
 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
 */
//
//  SampleBuilderMacro+Class.swift
//
//
//  Created by Philip Eram on 10/26/23.
//

import SwiftSyntax
import DataGenerator
import SwiftSyntaxMacros

extension SampleBuilderMacro {
    static func SampleBuilderMacroForClass(
        classDecl: ClassDeclSyntax,
        numberOfItems: Int,
        generatorType: DataGeneratorType,
        context: MacroExpansionContext
    ) -> [SwiftSyntax.DeclSyntax] {
        let validParameters = getValidParameterListFromClass(
            from: classDecl,
            generatorType: generatorType,
            context: context)
        
        let sampleCode = generateSampleCodeSyntax(
            sampleData: generateSampleData(
                parameters: validParameters,
                numberOfItems: numberOfItems,
                generatorType: generatorType
            )
        )
        
        return [DeclSyntax(sampleCode)]
    }
    
    static func getValidParameterListFromClass(
        from classDecl: ClassDeclSyntax,
        generatorType: DataGeneratorType,
        context: MacroExpansionContext
    ) -> [ParameterItem] {
        getValidParameterList(from: classDecl.memberBlock,
                              generatorType: generatorType,
                              context: context)
    }
    
}
