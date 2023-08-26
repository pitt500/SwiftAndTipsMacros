//
//  SampleBuilderMacro+Struct.swift
//  
//
//  Created by Pedro Rojas on 19/08/23.
//

import SwiftSyntax
import DataGenerator

extension SampleBuilderMacro {
    static func SampleBuilderMacroForStruct(
        structDecl: StructDeclSyntax,
        numberOfItems: Int,
        generatorType: DataGeneratorType
    ) -> [SwiftSyntax.DeclSyntax] {
        let validParameters = getValidParameterList(from: structDecl)
        
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
}
