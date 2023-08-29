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
