import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct SwiftAndTipsLibPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        BinaryStringMacro.self,
        SampleBuilderMacro.self,
    ]
}
