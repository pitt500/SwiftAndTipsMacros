// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that transform an Int into a binary representation and returned
/// as string. For example:
///
///     #binaryString(10)
///
/// produces a string `"1010"`.
@freestanding(expression)
public macro binaryString(_ value: Int) -> String = #externalMacro(module: "SwiftAndTipsLibMacros", type: "BinaryStringMacro")

@attached(member, names: named(sample))
public macro SampleBuilder(numberOfItems: Int) = #externalMacro(module: "SwiftAndTipsLibMacros", type: "SampleBuilderMacro")
