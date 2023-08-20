//
//  SampleBuilderMacro+ExprSyntax.swift
//  
//
//  Created by Pedro Rojas on 19/08/23.
//

import SwiftSyntax

extension SampleBuilderMacro {
    static func getExpressionSyntax(from type: TypeSyntax) -> ExprSyntax {
        if type.isArray {
            getArrayExprSyntax(
                arrayType: type.as(ArrayTypeSyntax.self)!
            )
        } else if type.isDictionary {
            getDictionaryExprSyntax(
                dictionaryType: type.as(DictionaryTypeSyntax.self)!
            )
        } else {
            getSimpleExprSyntax(simpleType: type.as(SimpleTypeIdentifierSyntax.self)!)
        }
    }
    
    static func getArrayExprSyntax(
        arrayType: ArrayTypeSyntax
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
                            from: TypeSyntax(arrayType.elementType)
                        )
                    )
                },
                rightSquare: .rightSquareBracketToken()
            )
        )
    }
    
    static func getDictionaryExprSyntax(
        dictionaryType: DictionaryTypeSyntax
    ) -> ExprSyntax {
        
        // We are not considering other types of keys (Arrays, dictionaries)
        guard let simpleKeyType = dictionaryType.keyType.as(SimpleTypeIdentifierSyntax.self)
        else {
            fatalError("The dictionary key is not convertible to SimpleTypeIdentifierSyntax")
        }
        
        if dictionaryType.valueType.isArray {
            let arrayValueType = dictionaryType.valueType.as(ArrayTypeSyntax.self)!
            
            return ExprSyntax(
                DictionaryExprSyntax {
                    DictionaryElementListSyntax {
                        DictionaryElementSyntax(
                            keyExpression: getSimpleExprSyntax(
                                simpleType: simpleKeyType
                            ),
                            valueExpression: getArrayExprSyntax(
                                arrayType: arrayValueType
                            )
                        )
                    }
                }
            )
        } else if dictionaryType.valueType.isDictionary {
            let dictionaryValueType = dictionaryType.valueType.as(DictionaryTypeSyntax.self)!
            
            return ExprSyntax(
                DictionaryExprSyntax {
                    DictionaryElementListSyntax {
                        DictionaryElementSyntax(
                            keyExpression: getSimpleExprSyntax(
                                simpleType: simpleKeyType
                            ),
                            valueExpression: getDictionaryExprSyntax(
                                dictionaryType: dictionaryValueType
                            )
                        )
                    }
                }
            )
        }
        
        // Assuming is a simple type
        guard let simpleValueType = dictionaryType.valueType.as(SimpleTypeIdentifierSyntax.self)
        else {
            fatalError("The dictionary value is not convertible to SimpleTypeIdentifierSyntax")
        }
        
        return ExprSyntax(
            DictionaryExprSyntax {
                DictionaryElementListSyntax {
                    DictionaryElementSyntax(
                        keyExpression: getSimpleExprSyntax(
                            simpleType: simpleKeyType
                        ),
                        valueExpression: getSimpleExprSyntax(
                            simpleType: simpleValueType
                        )
                    )
                }
            }
        )
    }
    
    static func getSimpleExprSyntax(
        simpleType: SimpleTypeIdentifierSyntax
    ) -> ExprSyntax {
        
        if let primitiveType = PrimitiveType(rawValue: simpleType.name.text) {
            return primitiveType.exprSyntax
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
