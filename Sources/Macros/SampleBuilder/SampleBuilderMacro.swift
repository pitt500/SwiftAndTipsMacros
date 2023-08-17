//
//  SampleBuilderMacro.swift
//  
//
//  Created by Pedro Rojas on 05/08/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SampleBuilderMacro: MemberMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw SampleBuilderError.notAnStruct
        }
        
        let numberOfItems = getNumberOfItems(from: node)
        
        if numberOfItems <= 0 {
            throw SampleBuilderError.argumentNotGreaterThanZero
        }
        
        let validParameters = getValidParameterList(from: structDecl)
        
        let sampleCode = generateSampleCodeSyntax(
            sampleElements: generateSampleArrayElements(
                parameters: validParameters,
                numberOfItems: numberOfItems
            )
        )
        
        return [DeclSyntax(sampleCode)]
    }
}

extension SampleBuilderMacro {
    
    static func getValidParameterList(
        from structDecl: StructDeclSyntax
    ) -> [InitParameterItem] {
        let storedPropertyMembers = structDecl.memberBlock.members
            .compactMap {
                $0.decl.as(VariableDeclSyntax.self)
            }
            .filter {
                $0.isStoredProperty
            }
        
        let initMembers = structDecl.memberBlock.members
            .compactMap {
                $0.decl.as(InitializerDeclSyntax.self)
            }
        
        if initMembers.isEmpty {
            // No custom init around. We use the memberwise initializer's properties:
            return storedPropertyMembers.compactMap {
                if let identifier = $0.bindings.first?
                    .pattern
                    .as(IdentifierPatternSyntax.self)?
                    .identifier.text,
                   let type = $0.bindings.first?
                    .typeAnnotation?
                    .type {
                    return (identifier, type)
                }
                
                return nil
            }.map {
                InitParameterItem(
                    identifierName: $0.0,
                    identifierType: $0.1
                )
            }
        }
        
        let largestParameterList = initMembers
            .map {
                getParametersFromInit(initSyntax: $0)
            }.max {
                $0.count < $1.count
            } ?? []
        
        return largestParameterList
    }
    
    static func getParametersFromInit(
        initSyntax: InitializerDeclSyntax
    ) -> [InitParameterItem] {
        let parameters = initSyntax.signature.input.parameterList
        
        return parameters.map {
            InitParameterItem(
                identifierName: $0.firstName.text,
                identifierType: $0.type
            )
        }
    }
    
    static func generateSampleCodeSyntax(
        sampleElements: ArrayElementListSyntax
    ) -> VariableDeclSyntax {
        VariableDeclSyntax(
            modifiers: ModifierListSyntax {
                DeclModifierSyntax(name: .keyword(.static))
            },
            bindingKeyword: .keyword(.var),
            bindings: PatternBindingListSyntax {
                PatternBindingSyntax(
                    pattern: IdentifierPatternSyntax(identifier: .identifier("sample")
                    ),
                    typeAnnotation: TypeAnnotationSyntax(
                        colon: .colonToken(),
                        type: ArrayTypeSyntax(
                            leftSquareBracket: .leftSquareBracketToken(),
                            elementType: SimpleTypeIdentifierSyntax(
                                name: .keyword(.Self)
                            ),
                            rightSquareBracket: .rightSquareBracketToken()
                        )
                    ),
                    accessor: .getter(
                        CodeBlockSyntax(
                            leftBrace: .leftBraceToken(),
                            statements: CodeBlockItemListSyntax {
                                CodeBlockItemSyntax(
                                    item: .expr(
                                        ExprSyntax(
                                            ArrayExprSyntax(
                                                leftSquare: .leftSquareBracketToken(),
                                                elements: sampleElements,
                                                rightSquare: .rightSquareBracketToken(leadingTrivia: .newline)
                                            )
                                        )
                                    )
                                )
                                
                            },
                            rightBrace: .rightBraceToken()
                        )
                    )
                )
            }
        )
    }
    
    static func generateSampleArrayElements(
        parameters: [InitParameterItem],
        numberOfItems: Int
    ) -> ArrayElementListSyntax {
        let parameterListSyntax = getSampleElementParameterListSyntax(
            parameters: parameters
        )
        
        var arrayElementListSyntax = ArrayElementListSyntax()
        
        for _ in 1...numberOfItems {
            arrayElementListSyntax = arrayElementListSyntax
                .appending(
                    ArrayElementSyntax(
                        leadingTrivia: .newline,
                        expression: FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(
                                dot: .periodToken(),
                                name: .keyword(.`init`)
                            ),
                            leftParen: .leftParenToken(),
                            argumentList: parameterListSyntax,
                            rightParen: .rightParenToken()
                        ),
                        trailingComma: .commaToken()
                    )
                )
        }
        
        return arrayElementListSyntax
    }
    
    static func getNumberOfItems(from node: SwiftSyntax.AttributeSyntax) -> Int {
        guard let argumentTuple = node.argument?.as(TupleExprElementListSyntax.self)?.first,
              let integerExpression = argumentTuple.expression.as(IntegerLiteralExprSyntax.self),
              let numberOfItems = Int(integerExpression.digits.text)
        else {
            fatalError("Compiler bug: Argument must exist")
        }
        
        return numberOfItems
    }
    
    static func getSampleElementParameterListSyntax(
        parameters: [InitParameterItem]
    ) -> TupleExprElementListSyntax {
        
        var parameterList = TupleExprElementListSyntax()
        
        for parameter in parameters {
            
            let expressionSyntax =
            if parameter.identifierType.isArray {
                getArrayExprSyntax(
                    arrayType: parameter.identifierType.as(ArrayTypeSyntax.self)!
                )
            } else if parameter.identifierType.isDictionary {
                getDictionaryExprSyntax(
                    dictionaryType: parameter.identifierType.as(DictionaryTypeSyntax.self)!
                )
            } else {
                getSimpleExprSyntax(simpleType: parameter.identifierType.as(SimpleTypeIdentifierSyntax.self)!)
            }
            
            let isLast = parameter.identifierName == parameters.last?.identifierName
            let parameterElement = TupleExprElementSyntax(
                label: .identifier(parameter.identifierName),
                colon: .colonToken(),
                expression: expressionSyntax,
                trailingComma: isLast ? nil : .commaToken()
            )
            
            parameterList = parameterList
                .appending(parameterElement)
        }
        
        return parameterList
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
    
    static func getArrayExprSyntax(
        arrayType: ArrayTypeSyntax
    ) -> ExprSyntax {
        guard let simpleType = arrayType.elementType.as(SimpleTypeIdentifierSyntax.self)
        else {
            fatalError("The array element is not convertible to SimpleTypeIdentifierSyntax")
        }
        
        if  let primitiveType = PrimitiveType(rawValue: simpleType.name.text) {
            return ExprSyntax(
                ArrayExprSyntax(
                    leftSquare: .leftSquareBracketToken(),
                    elements: ArrayElementListSyntax {
                        ArrayElementSyntax(
                            expression: primitiveType.exprSyntax
                        )
                    },
                    rightSquare: .rightSquareBracketToken()
                )
            )
        }
        
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
}
