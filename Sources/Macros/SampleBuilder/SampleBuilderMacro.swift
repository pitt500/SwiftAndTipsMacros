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
        
        let numberOfItems = try getNumberOfItems(from: node)
        
        if numberOfItems <= 0 {
            throw SampleBuilderError.argumentNotGreaterThanZero
        }
        
        if let enumDecl = declaration.as(EnumDeclSyntax.self) {
            return try SampleBuilderMacroForEnum(
                enumDecl: enumDecl,
                numberOfItems: numberOfItems
            )
        }
        
        if let structDecl = declaration.as(StructDeclSyntax.self) {
            return SampleBuilderMacroForStruct(
                structDecl: structDecl,
                numberOfItems: numberOfItems
            )
        }
        
        throw SampleBuilderError.notAnStructOrEnum
    }
}

extension SampleBuilderMacro {
    static func SampleBuilderMacroForStruct(
        structDecl: StructDeclSyntax,
        numberOfItems: Int
    ) -> [SwiftSyntax.DeclSyntax] {
        let validParameters = getValidParameterList(from: structDecl)
        
        let sampleCode = generateSampleCodeSyntax(
            sampleData: generateSampleArrayElements(
                parameters: validParameters,
                numberOfItems: numberOfItems
            )
        )
        
        return [DeclSyntax(sampleCode)]
    }
    
    static func SampleBuilderMacroForEnum(
        enumDecl: EnumDeclSyntax,
        numberOfItems: Int
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        let cases = enumDecl.memberBlock.members.compactMap {
            $0.decl.as(EnumCaseDeclSyntax.self)
        }
        
        if cases.isEmpty {
            throw SampleBuilderError.enumWithEmptyCases
        }

        let sampleCode = generateSampleCodeSyntax(
            sampleData: generateSampleArrayCases(
                cases: cases,
                numberOfItems: numberOfItems
            )
        )
        
        return [DeclSyntax(sampleCode)]
    }
}

// Enums
extension SampleBuilderMacro {
    static func generateSampleArrayCases(
        cases: [EnumCaseDeclSyntax],
        numberOfItems: Int
    ) -> ArrayElementListSyntax {
        var arrayElementListSyntax = ArrayElementListSyntax()
        
        let totalNumberOfCases = replicateCases(
            cases: cases,
            numberOfItems: numberOfItems
        )
        
        for caseItem in totalNumberOfCases {
            let parameters = caseItem.parameterTypes.map {
                ParameterItem(
                    identifierName: nil,
                    identifierType: $0
                )
            }
            
            let caseExpression =
            if caseItem.hasAssociatedValues {
                ExprSyntax(
                    FunctionCallExprSyntax(
                        calledExpression: MemberAccessExprSyntax(
                            dot: .periodToken(),
                            name: .identifier(caseItem.name)
                        ),
                        leftParen: .leftParenToken(),
                        argumentList: getSampleElementParameterListSyntax(
                            parameters: parameters
                        ),
                        rightParen: .rightParenToken()
                    )
                )
            } else {
                ExprSyntax(
                    MemberAccessExprSyntax(
                        dot: .periodToken(),
                        name: .identifier(caseItem.name)
                    )
                )
            }
            
            arrayElementListSyntax = arrayElementListSyntax.appending(
                ArrayElementSyntax(
                    leadingTrivia: .newline,
                    expression: caseExpression,
                    trailingComma: .commaToken()
                )
            )
        }
        
        return arrayElementListSyntax
    }
    
    static func replicateCases(
        cases: [EnumCaseDeclSyntax],
        numberOfItems: Int
    ) -> [EnumCaseDeclSyntax] {
        var totalNumberOfCases: [EnumCaseDeclSyntax] = []
        
        /*
         we will extend the cases according to the number of items.
         for example, if cases are [case1, case2, case3]
         and numberOfItems = 2, the result should be [case1, case2].
         
         If cases are [case1, case2] and numberOfItems = 7, the result
         should be [case1, case2, case1, case2, case1, case2, case1]
         */
        for i in 0..<numberOfItems {
            totalNumberOfCases.append(
                cases[i % cases.count]
            )
        }
        
        return totalNumberOfCases
    }
}

// Structs
extension SampleBuilderMacro {
    
    static func getValidParameterList(
        from structDecl: StructDeclSyntax
    ) -> [ParameterItem] {
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
                ParameterItem(
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
    ) -> [ParameterItem] {
        let parameters = initSyntax.signature.input.parameterList
        
        return parameters.map {
            ParameterItem(
                identifierName: $0.firstName.text,
                identifierType: $0.type
            )
        }
    }
    
    static func generateSampleCodeSyntax(
        sampleData: ArrayElementListSyntax
    ) -> VariableDeclSyntax {
        let returnType = ArrayTypeSyntax(
            leftSquareBracket: .leftSquareBracketToken(),
            elementType: SimpleTypeIdentifierSyntax(
                name: .keyword(.Self)
            ),
            rightSquareBracket: .rightSquareBracketToken()
        )
        
        return VariableDeclSyntax(
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
                        type: returnType
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
                                                elements: sampleData,
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
        parameters: [ParameterItem],
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
    
    static func getNumberOfItems(
        from node: SwiftSyntax.AttributeSyntax
    ) throws -> Int {
        guard let argumentTuple = node.argument?.as(TupleExprElementListSyntax.self)?.first,
              let integerExpression = argumentTuple.expression.as(IntegerLiteralExprSyntax.self),
              let numberOfItems = Int(integerExpression.digits.text)
        else {
            fatalError("Compiler bug: Argument must exist")
        }
        
        return numberOfItems
    }
    
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
    
    static func getSampleElementParameterListSyntax(
        parameters: [ParameterItem]
    ) -> TupleExprElementListSyntax {
        
        var parameterList = TupleExprElementListSyntax()
        
        for parameter in parameters {
            
            let expressionSyntax = getExpressionSyntax(from: parameter.identifierType)
            
            let isNotLast = parameter.identifierType != parameters.last?.identifierType
            let parameterElement = TupleExprElementSyntax(
                label: parameter.hasName ? .identifier(parameter.identifierName!) : nil,
                colon: parameter.hasName ? .colonToken() : nil,
                expression: expressionSyntax,
                trailingComma: isNotLast ? .commaToken() : nil
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
