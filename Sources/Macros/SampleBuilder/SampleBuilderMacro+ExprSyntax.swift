//
//  SampleBuilderMacro+ExprSyntax.swift
//  
//
//  Created by Pedro Rojas on 19/08/23.
//

import SwiftSyntax
import DataGenerator

extension SampleBuilderMacro {
    static func getExpressionSyntax(
        from type: TypeSyntax,
        generatorType: DataGeneratorType
    ) -> ExprSyntax {
        if type.isArray {
            getArrayExprSyntax(
                arrayType: type.as(ArrayTypeSyntax.self)!,
                generatorType: generatorType
            )
        } else if type.isDictionary {
            getDictionaryExprSyntax(
                dictionaryType: type.as(DictionaryTypeSyntax.self)!,
                generatorType: generatorType
            )
        } else {
            getSimpleExprSyntax(
                simpleType: type.as(SimpleTypeIdentifierSyntax.self)!,
                generatorType: generatorType
            )
        }
    }
    
    static func getArrayExprSyntax(
        arrayType: ArrayTypeSyntax,
        generatorType: DataGeneratorType
    ) -> ExprSyntax {
        
        if let simpleType = arrayType.elementType.as(SimpleTypeIdentifierSyntax.self),
           PrimitiveType(rawValue: simpleType.name.text) == nil {
            // Custom array type that attaches SampleBuilder in its declaration:
            return ExprSyntax(
                MemberAccessExprSyntax(
                    base: IdentifierExprSyntax(
                        identifier: simpleType.name
                    ),
                    dot: .periodToken(),
                    name: .identifier("sample")
                )
            )
        }
        
        return ExprSyntax(
            ArrayExprSyntax(
                leftSquare: .leftSquareBracketToken(),
                elements: ArrayElementListSyntax {
                    ArrayElementSyntax(
                        expression: getExpressionSyntax(
                            from: TypeSyntax(arrayType.elementType),
                            generatorType: generatorType
                        )
                    )
                },
                rightSquare: .rightSquareBracketToken()
            )
        )
    }
    
    static func getDictionaryExprSyntax(
        dictionaryType: DictionaryTypeSyntax,
        generatorType: DataGeneratorType
    ) -> ExprSyntax {
        ExprSyntax(
            DictionaryExprSyntax {
                DictionaryElementListSyntax {
                    DictionaryElementSyntax(
                        keyExpression: getExpressionSyntax(
                            from: dictionaryType.keyType,
                            generatorType: generatorType
                        ),
                        valueExpression: getExpressionSyntax(
                            from: dictionaryType.valueType,
                            generatorType: generatorType
                        )
                    )
                }
            }
        )
    }
    
    static func getSimpleExprSyntax(
        simpleType: SimpleTypeIdentifierSyntax,
        generatorType: DataGeneratorType
    ) -> ExprSyntax {
        
        if let primitiveType = PrimitiveType(rawValue: simpleType.name.text) {
            return primitiveType.exprSyntax(dataGeneratorType: generatorType)
        }
        
        // Custom type that attaches SampleBuilder in its declaration:
        return ExprSyntax(
            ForcedValueExprSyntax(
                expression: MemberAccessExprSyntax(
                    base: MemberAccessExprSyntax(
                        base: IdentifierExprSyntax(
                            identifier: simpleType.name
                        ),
                        dot: .periodToken(),
                        name: .identifier("sample")
                    ),
                    dot: .periodToken(),
                    name: .identifier("first")
                ),
                exclamationMark: .exclamationMarkToken()
            )
        )
    }
}
