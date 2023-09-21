/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

//
//  BinaryStringMacro.swift
//  
//
//  Created by Pedro Rojas on 05/08/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

/// Implementation of the `binaryString` macro, which takes an expression
/// of type `Int` and produces a string value containing its binary representation . For example:
///
///     #binary(111)
///
/// will expand to:
///
///     "1101111"
public struct BinaryStringMacro: ExpressionMacro {
    public static func expansion(
        of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> SwiftSyntax.ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }
        
        guard let num = Int("\(argument)")
        else {
            throw BinaryStringError.notAnInt
        }
        
        let binaryString = String(num, radix: 2)
        
        return ExprSyntax(literal: binaryString)
    }
}

enum BinaryStringError: Error, CustomStringConvertible {
    case notAnInt
    
    var description: String {
        switch self {
        case .notAnInt:
            return "The argument is not an Int literal"
        }
    }
}
