/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/
//
//  SampleBuilderMacro+ParameterList.swift
//
//
//  Created by Philip Eram on 11/2/23.
//

import SwiftSyntax
import DataGenerator
import DataCategory
import SwiftSyntaxMacros

typealias declSyntax = DeclSyntaxProtocol & SyntaxHashable

extension SampleBuilderMacro {
    static func getValidParameterList(
        from members: MemberBlockSyntax,
        generatorType: DataGeneratorType,
        context: MacroExpansionContext
    ) -> [ParameterItem] {
        let storedPropertyMembers = members.members
            .compactMap {
                $0.decl.as(VariableDeclSyntax.self)
            }
            .filter {
                $0.isStoredProperty
            }
        
        let initMember = members.members
            .compactMap {
                $0.decl.as(InitializerDeclSyntax.self)
            }
        
        if initMember.isEmpty {
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
        
        
        let largestParameterList = initMember
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
}
