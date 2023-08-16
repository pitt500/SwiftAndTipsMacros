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
        
        let validMembers = structDecl.memberBlock.members
            .filter {
                $0.decl.as(VariableDeclSyntax.self)?.isStoredProperty ?? false
            }
        
        let sampleCode = generateSampleCodeSyntax(
            sampleElements: generateSampleArrayElements(
                members: validMembers,
                numberOfItems: numberOfItems
            )
        )
        
        return [DeclSyntax(sampleCode)]
    }
}

extension SampleBuilderMacro {
    
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
        members: [MemberDeclListSyntax.Element],
        numberOfItems: Int
    ) -> ArrayElementListSyntax {
        let parameterList = getSampleElementParameterList(members: members)
        
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
                            argumentList: parameterList,
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
    
    static func getSampleElementParameterList(
        members: [MemberDeclListSyntax.Element]
    ) -> TupleExprElementListSyntax {
        
        var parameterList = TupleExprElementListSyntax()
        
        for member in members {
            guard let variableDecl = member.decl.as(VariableDeclSyntax.self),
                  let identifierDecl = variableDecl.bindings.first?.pattern.as(IdentifierPatternSyntax.self),
                  let identifierType = variableDecl.bindings.first?.typeAnnotation?.type
            else {
                fatalError("Compiler Bug")
            }
            
            let expressionSyntax =
            if identifierType.isArray {
                getArrayExprSyntax(arrayType: identifierType.as(ArrayTypeSyntax.self)!)
            } else {
                getSimpleExprSyntax(simpleType: identifierType.as(SimpleTypeIdentifierSyntax.self)!)
            }
            
            let parameterElement = TupleExprElementSyntax(
                label: identifierDecl.identifier,
                colon: .colonToken(),
                expression: expressionSyntax,
                trailingComma: member == members.last ? nil : .commaToken()
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
