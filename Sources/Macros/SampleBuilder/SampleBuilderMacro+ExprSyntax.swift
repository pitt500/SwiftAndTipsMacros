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
        ExprSyntax(
            DictionaryExprSyntax {
                DictionaryElementListSyntax {
                    DictionaryElementSyntax(
                        keyExpression: getExpressionSyntax(
                            from: dictionaryType.keyType
                        ),
                        valueExpression: getExpressionSyntax(
                            from: dictionaryType.valueType
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
