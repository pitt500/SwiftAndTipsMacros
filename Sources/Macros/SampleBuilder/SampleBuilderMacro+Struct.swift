//
//  SampleBuilderMacro+Struct.swift
//  
//
//  Created by Pedro Rojas on 19/08/23.
//

import SwiftSyntax
import DataGenerator
import DataCategory
import SwiftSyntaxMacros

extension SampleBuilderMacro {
    static func SampleBuilderMacroForStruct(
        structDecl: StructDeclSyntax,
        numberOfItems: Int,
        generatorType: DataGeneratorType,
        context: MacroExpansionContext
    ) -> [SwiftSyntax.DeclSyntax] {
        let validParameters = getValidParameterList(
            from: structDecl,
            generatorType: generatorType,
            context: context
        )
        
        let sampleCode = generateSampleCodeSyntax(
            sampleData: generateSampleData(
                parameters: validParameters,
                numberOfItems: numberOfItems,
                generatorType: generatorType
            )
        )
        
        return [DeclSyntax(sampleCode)]
    }
    
    static func getValidParameterList(
        from structDecl: StructDeclSyntax,
        generatorType: DataGeneratorType,
        context: MacroExpansionContext
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
                    
                    return (identifier, type, getDataCategory(from: $0, generatorType: generatorType, context: context))
                }
                
                return nil
            }.map {
                ParameterItem(
                    identifierName: $0.0,
                    identifierType: $0.1,
                    category: $0.2
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
    
    static func getDataCategory(
        from variableDecl: VariableDeclSyntax,
        generatorType: DataGeneratorType,
        context: MacroExpansionContext
    ) -> DataCategory? {
        
        // Check if SampleBuilderItem is used.
        guard let attribute = variableDecl.attributes
                .first(where: {
                    $0.as(AttributeSyntax.self)?
                        .attributeName
                        .as(IdentifierTypeSyntax.self)?
                        .name.text == "SampleBuilderItem"
                })?.as(AttributeSyntax.self)
              
        else {
            return DataCategory.noCategory
        }
        
        if generatorType == .default {
            // Since default will always the return the same value,
            // Using SampleBuilderItem is useless and will throw a warning.
            SampleBuilderDiagnostic.report(
                diagnostic: .sampleBuilderItemRedundant,
                node: Syntax(attribute),
                context: context
            )
        }
        
        if let simpleCategoryString = attribute // All categories except image
            .arguments?
            .as(LabeledExprListSyntax.self)?
            .first?.as(LabeledExprSyntax.self)?
            .expression.as(MemberAccessExprSyntax.self)?
            .declName.baseName.text {
            
            return DataCategory(rawValue: simpleCategoryString)
        }
        
        if let imageCategoryExpression = attribute
            .arguments?
            .as(LabeledExprListSyntax.self)?
            .first?.as(LabeledExprSyntax.self)?
            .expression.as(FunctionCallExprSyntax.self),
           
            imageCategoryExpression
            .calledExpression.as(MemberAccessExprSyntax.self)?
            .declName.baseName.text == "image" {
            
            // Image's width and height
            let argumentsValues = imageCategoryExpression.arguments.compactMap {
                Int($0.expression.as(IntegerLiteralExprSyntax.self)?.literal.text ?? "")
            }
            
            guard argumentsValues.count == 2
            else {
                return DataCategory.noCategory
            }
            
            return DataCategory(imageWidth: argumentsValues[0], height: argumentsValues[1])
        }
        
        return DataCategory.noCategory
    }
    
    static func getParametersFromInit(
        initSyntax: InitializerDeclSyntax
    ) -> [ParameterItem] {
        let parameters = initSyntax.signature.parameterClause.parameters
        
        return parameters.map {
            ParameterItem(
                identifierName: $0.firstName.text,
                identifierType: $0.type,
                category: nil
            )
        }
    }
    
    static func generateSampleData(
        parameters: [ParameterItem],
        numberOfItems: Int,
        generatorType: DataGeneratorType
    ) -> ArrayElementListSyntax {
        let parameterList = getParameterListForSampleElement(
            parameters: parameters,
            generatorType: generatorType
        )
        
        var arrayElementListSyntax = ArrayElementListSyntax()
        
        for _ in 1...numberOfItems {
            arrayElementListSyntax
                .append(
                    ArrayElementSyntax(
                        leadingTrivia: .newline,
                        expression: FunctionCallExprSyntax(
                            calledExpression: MemberAccessExprSyntax(
                                period: .periodToken(),
                                name: .keyword(.`init`)
                            ),
                            leftParen: .leftParenToken(),
                            arguments: parameterList,
                            rightParen: .rightParenToken()
                        ),
                        trailingComma: .commaToken()
                    )
                )
        }
        
        return arrayElementListSyntax
    }
}
