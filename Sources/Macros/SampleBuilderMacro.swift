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

        var sampleCode = """
        
        static var sample: [Self] {
            [

        """
        
        let validMembers = structDecl.memberBlock.members
            .filter {
                $0.decl.as(VariableDeclSyntax.self)?.isStoredProperty ?? false
            }
        
        for _ in 1...numberOfItems {
            
            var parameterList = ""
            
            for member in validMembers {
                guard let variableDecl = member.decl.as(VariableDeclSyntax.self),
                      let identifierDecl = variableDecl.bindings.first?.pattern.as(IdentifierPatternSyntax.self),
                      let identifierType = variableDecl.bindings.first?.typeAnnotation?.type
                else {
                    fatalError("Compiler Bug")
                }
                
                do {
                    parameterList += try getParameterItem(
                        identifierName: identifierDecl.identifier,
                        identifierType: identifierType,
                        isLast: member == validMembers.last
                    )
                } catch {
                    throw error
                }
            }
            
            sampleCode += """
                .init(\(parameterList)),
            
            """
        }
        
        sampleCode += """
            ]
        }
        """
        
        #warning("Fix this test")
        //return [DeclSyntax(stringLiteral: sampleCode)]
        return [
            DeclSyntax(
                generateSampleCodeSyntax(
                    sampleElements: generateSampleArrayElements()
                )
            )
        ]
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
                                                rightSquare: .rightSquareBracketToken()
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
    
    static func generateSampleArrayElements() -> ArrayElementListSyntax {
        ArrayElementListSyntax {
            ArrayElementSyntax(
                expression: FunctionCallExprSyntax(
                    calledExpression: MemberAccessExprSyntax(
                        dot: .periodToken(),
                        name: .keyword(.`init`)
                    ),
                    leftParen: .leftParenToken(),
                    argumentList: TupleExprElementListSyntax {
                        TupleExprElementSyntax(
                            label: .identifier("x"),
                            colon: .colonToken(),
                            expression: IntegerLiteralExprSyntax(
                                digits: .integerLiteral("0")
                            ),
                            trailingComma: .commaToken()
                        )
                        TupleExprElementSyntax(
                            label: .identifier("y"),
                            colon: .colonToken(),
                            expression: StringLiteralExprSyntax(content: "Hello World"),
                            trailingComma: .commaToken()
                        )
                    },
                    rightParen: .rightParenToken()
                ),
                trailingComma: .commaToken()
            )
        }
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
    
    static func getParameterItem(
        identifierName: TokenSyntax,
        identifierType: TypeSyntax,
        isLast: Bool
    ) throws -> String {
        
        var parameterItem = ""
        
        #warning("Refactor all this mess!")
        
        if let arrayType = identifierType.as(ArrayTypeSyntax.self),
            let elementType = arrayType.elementType.as(SimpleTypeIdentifierSyntax.self) {
            
            if let primitiveType = PrimitiveType(rawValue: elementType.name.text) {
                parameterItem = "\(identifierName.text): [\(primitiveType.default)]"
            } else {
                parameterItem = "\(identifierName.text): \(elementType.name.text).sample"
            }
            
        } else if let simpleType = identifierType.as(SimpleTypeIdentifierSyntax.self) {
            if let primitiveType = PrimitiveType(rawValue: simpleType.name.text) {
                parameterItem = "\(identifierName.text): \(primitiveType.default)"
            } else {
                parameterItem = "\(identifierName.text): \(simpleType.name.text).sample.first!"
            }
        } else {
            throw SampleBuilderError.typeNotSupported(typeName: identifierType.description)
        }
        
        if !isLast {
            parameterItem += ", "
        }
        
        return parameterItem
    }
}

extension VariableDeclSyntax {
    var isStoredProperty: Bool {
        // Stored properties cannot have more than 1 binding in its declaration.
        guard bindings.count == 1
        else {
            return false
        }
        
        guard let accesor = bindings.first?.accessor
        else {
            // Nothing to review. It's a valid stored property
            return true
        }
        
        switch accesor {
        case .accessors(let accesorBlockSyntax):
            // Observers are valid accesors only
            let validAccesors = Set<TokenKind>([
                .keyword(.willSet), .keyword(.didSet)
            ])
            
            let hasValidAccesors = accesorBlockSyntax.accessors.contains {
                // Other kind of accesors will make the variable a computed property
                validAccesors.contains($0.accessorKind.tokenKind)
            }
            return hasValidAccesors
        case .getter:
            // A variable with only a getter is not valid for initialization.
            return false
        }
        
    }
    
    var isPublic: Bool {
        modifiers?.contains {
            $0.name.tokenKind == .keyword(.public)
        } ?? false
    }
    
    var isPrivate: Bool {
        modifiers?.contains {
            $0.name.tokenKind == .keyword(.private)
        } ?? false
    }
}

extension StructDeclSyntax {
    var hasExplicitInit: Bool {
        return true
        #warning("missing implementation")
    }
}

enum SampleBuilderError: Error, CustomStringConvertible {
    case notAnStruct
    case argumentNotGreaterThanZero
    case typeNotSupported(typeName: String)
    
    var description: String {
        switch self {
        case .notAnStruct:
            return "This macro can only be applied to structs"
        case .argumentNotGreaterThanZero:
            return "Argument is not greater than zero"
        case .typeNotSupported(let typeName):
            return "\(typeName) is not supported"
        }
    }
}

enum PrimitiveType: String {
    case int = "Int"
    case int8 = "Int8"
    case int16 = "Int16"
    case int32 = "Int32"
    case int64 = "Int64"
    case uInt8 = "UInt8"
    case uInt16 = "UInt16"
    case uInt32 = "UInt32"
    case uInt64 = "UInt64"
    case float = "Float"
    case double = "Double"
    case string = "String"
    case bool = "Bool"
    case data = "Data"
    case date = "Date"
    case uuid = "UUID"
    case cgPoint = "CGPoint"
    case cgRect = "CGRect"
    case cgSize = "CGSize"
    case cgVector = "CGVector"
    case cgFloat = "CGFloat"
    case url = "URL"
    
    var `default`: String {
        switch self {
        case .int, .int8, .int16, .int32, .int64, .uInt8, .uInt16, .uInt32, .uInt64, .double, .float, .cgFloat:
            "0"
        case .string:
            #""Hello World""#
        case .bool:
            "true"
        case .data:
            "Data()"
        case .date:
            "Date()"
        case .uuid:
            "UUID()"
        case .cgPoint:
            "CGPoint()"
        case .cgRect:
            "CGRect()"
        case .cgSize:
            "CGSize()"
        case .cgVector:
            "CGVector()"
        case .url:
            #"URL(string: "https://www.apple.com")!"#
        }
    }
}
