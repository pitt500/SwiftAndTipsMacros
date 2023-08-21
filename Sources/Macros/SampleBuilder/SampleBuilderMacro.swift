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
import SwiftDiagnostics

public struct SampleBuilderMacro: MemberMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        let numberOfItems = try getNumberOfItems(from: node)
        
        if numberOfItems <= 0 {
            SampleBuilderDiagnostic.report(
                diagnostic: .argumentNotGreaterThanZero,
                node: node,
                context: context
            )
            return []
        }
        
        if let enumDecl = declaration.as(EnumDeclSyntax.self) {
            return try SampleBuilderMacroForEnum(
                enumDecl: enumDecl,
                numberOfItems: numberOfItems,
                node: node,
                context: context
            )
        }
        
        if let structDecl = declaration.as(StructDeclSyntax.self) {
            return SampleBuilderMacroForStruct(
                structDecl: structDecl,
                numberOfItems: numberOfItems
            )
        }
        
        SampleBuilderDiagnostic.report(
            diagnostic: .notAnStructOrEnum,
            node: node,
            context: context
        )
        return []
    }
}

extension SampleBuilderMacro {
    
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
    
    //Used for both Structs and Enums
    static func getParameterListForSampleElement(
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
}
