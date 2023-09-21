/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

//
//  SampleBuilderMacro+ExprSyntax.swift
//  
//
//  Created by Pedro Rojas on 19/08/23.
//

import SwiftSyntax
import DataGenerator
import DataCategory

extension SampleBuilderMacro {
    static func getExpressionSyntax(
        from type: TypeSyntax,
        generatorType: DataGeneratorType,
        category: DataCategory?
    ) -> ExprSyntax {
        if type.isArray {
            getArrayExprSyntax(
                arrayType: type.as(ArrayTypeSyntax.self)!,
                generatorType: generatorType, 
                category: category
            )
        } else if type.isDictionary {
            getDictionaryExprSyntax(
                dictionaryType: type.as(DictionaryTypeSyntax.self)!,
                generatorType: generatorType, 
                category: category
            )
        } else {
            getSimpleExprSyntax(
                simpleType: type.as(IdentifierTypeSyntax.self)!,
                generatorType: generatorType, 
                category: category
            )
        }
    }
    
    static func getArrayExprSyntax(
        arrayType: ArrayTypeSyntax,
        generatorType: DataGeneratorType,
        category: DataCategory?
    ) -> ExprSyntax {
        
        if let simpleType = arrayType.element.as(IdentifierTypeSyntax.self),
           SupportedType(rawValue: simpleType.name.text) == nil {
            // Custom array type that attaches SampleBuilder in its declaration:
            return ExprSyntax(
                MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(
                        baseName: simpleType.name
                    ),
                    period: .periodToken(),
                    name: .identifier("sample")
                )
            )
        }
        
        return ExprSyntax(
            ArrayExprSyntax(
                leftSquare: .leftSquareToken(),
                elements: ArrayElementListSyntax {
                    ArrayElementSyntax(
                        expression: getExpressionSyntax(
                            from: TypeSyntax(arrayType.element),
                            generatorType: generatorType, 
                            category: category
                        )
                    )
                },
                rightSquare: .rightSquareToken()
            )
        )
    }
    
    static func getDictionaryExprSyntax(
        dictionaryType: DictionaryTypeSyntax,
        generatorType: DataGeneratorType,
        category: DataCategory?
    ) -> ExprSyntax {
        ExprSyntax(
            DictionaryExprSyntax {
                DictionaryElementListSyntax {
                    DictionaryElementSyntax(
                        key: getExpressionSyntax(
                            from: dictionaryType.key,
                            generatorType: generatorType, 
                            category: category
                        ),
                        value: getExpressionSyntax(
                            from: dictionaryType.value,
                            generatorType: generatorType, 
                            category: category
                        )
                    )
                }
            }
        )
    }
    
    static func getSimpleExprSyntax(
        simpleType: IdentifierTypeSyntax,
        generatorType: DataGeneratorType,
        category: DataCategory?
    ) -> ExprSyntax {
        
        if let supportedType = SupportedType(rawValue: simpleType.name.text) {
            return supportedType.exprSyntax(
                dataGeneratorType: generatorType,
                category: category
            )
        }
        
        // Custom type that attaches SampleBuilder in its declaration:
        return ExprSyntax(
            ForceUnwrapExprSyntax(
                expression: MemberAccessExprSyntax(
                    base: MemberAccessExprSyntax(
                        base: DeclReferenceExprSyntax(
                            baseName: simpleType.name
                        ),
                        period: .periodToken(),
                        name: .identifier("sample")
                    ),
                    period: .periodToken(),
                    name: .identifier("first")
                ),
                exclamationMark: .exclamationMarkToken()
            )
        )
    }
}
