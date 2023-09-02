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
import DataGenerator

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
                node: Syntax(declaration),
                context: context
            )
            return []
        }
        
        let generatorType = getDataGeneratorType(from: node)
        
        if let enumDecl = declaration.as(EnumDeclSyntax.self) {
            return SampleBuilderMacroForEnum(
                enumDecl: enumDecl,
                numberOfItems: numberOfItems,
                generatorType: generatorType,
                context: context
            )
        }
        
        if let structDecl = declaration.as(StructDeclSyntax.self) {
            return SampleBuilderMacroForStruct(
                structDecl: structDecl,
                numberOfItems: numberOfItems,
                generatorType: generatorType, 
                context: context
            )
        }
        
        SampleBuilderDiagnostic.report(
            diagnostic: .notAnStructOrEnum,
            node: Syntax(declaration),
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
    
    static func getDataGeneratorType(
        from node: SwiftSyntax.AttributeSyntax
    ) -> DataGeneratorType {
        guard let argumentTuple = node.argument?.as(TupleExprElementListSyntax.self)
        else {
            fatalError("Compiler bug: Argument must exist")
        }

        guard let generatorArgument = argumentTuple.first(where: { $0.as(TupleExprElementSyntax.self)?.label?.text == "dataGeneratorType" }),
              let argumentValue = generatorArgument.expression.as(MemberAccessExprSyntax.self)?.name,
              let generatorType = DataGeneratorType(rawValue: argumentValue.text)
        else {
            // return default generator type
            return .random
        }
        
        return generatorType
    }
    
    static func getNumberOfItems(
        from node: SwiftSyntax.AttributeSyntax
    ) throws -> Int {
        guard let argumentTuple = node.argument?.as(TupleExprElementListSyntax.self)?.first
        else {
            fatalError("Compiler bug: Argument must exist")
        }
        
        if let prefixExpression = argumentTuple
            .expression
            .as(PrefixOperatorExprSyntax.self) {
            
            return negativeNumberOfItems(expression: prefixExpression)
        } else if let integerExpression = argumentTuple
                .expression
                .as(IntegerLiteralExprSyntax.self),
                let numberOfItems = Int(integerExpression.digits.text) {
            return numberOfItems
        }
        
        return 0 // Will throw .argumentNotGreaterThanZero in Xcode
    }
    
    static func negativeNumberOfItems(
        expression: PrefixOperatorExprSyntax
    ) -> Int {
        guard
            let operatorToken = expression
                .operatorToken?
                .text,
            let integerExpression = expression
                .postfixExpression
                .as(IntegerLiteralExprSyntax.self),
            let numberOfItems = Int(operatorToken + integerExpression.digits.text)
        else {
            return 0 // Will throw .argumentNotGreaterThanZero in Xcode
        }
        
        return numberOfItems
    }
    
    //Used for both Structs and Enums
    static func getParameterListForSampleElement(
        parameters: [ParameterItem],
        generatorType: DataGeneratorType
    ) -> TupleExprElementListSyntax {
        
        var parameterList = TupleExprElementListSyntax()
        
        for parameter in parameters {
            
            let expressionSyntax = getExpressionSyntax(
                from: parameter.identifierType,
                generatorType: generatorType,
                category: parameter.category
            )
            
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
