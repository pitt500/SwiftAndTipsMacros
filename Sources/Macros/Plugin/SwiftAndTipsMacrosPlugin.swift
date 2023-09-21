/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct SwiftAndTipsMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BinaryStringMacro.self,
        SampleBuilderMacro.self,
        SampleBuilderItemMacro.self,
    ]
}
