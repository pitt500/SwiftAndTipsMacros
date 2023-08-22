//
//  SampleBuilderMacro+Enum.swift
//  
//
//  Created by Pedro Rojas on 19/08/23.
//

import SwiftSyntax
import SwiftSyntaxMacros

// Enums
extension SampleBuilderMacro {
    static func SampleBuilderMacroForEnum(
        enumDecl: EnumDeclSyntax,
        numberOfItems: Int,
        context: some SwiftSyntaxMacros.MacroExpansionContext
    ) -> [SwiftSyntax.DeclSyntax] {
        
        let cases = enumDecl.memberBlock.members.compactMap {
            $0.decl.as(EnumCaseDeclSyntax.self)
        }
        
        if cases.isEmpty {
            SampleBuilderDiagnostic.report(
                diagnostic: .enumWithEmptyCases,
                node: enumDecl,
                context: context
            )
            return []
        }

        let sampleCode = generateSampleCodeSyntax(
            sampleData: generateSampleArrayCases(
                cases: cases,
                numberOfItems: numberOfItems
            )
        )
        
        return [DeclSyntax(sampleCode)]
    }
    
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
                        argumentList: getParameterListForSampleElement(
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
