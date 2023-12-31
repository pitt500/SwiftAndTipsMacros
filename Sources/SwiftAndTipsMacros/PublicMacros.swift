/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

import DataGenerator

/// A macro that transform an Int into a binary representation and returned
/// as string. For example:
///
///     #binaryString(10)
///
/// produces a string `"1010"`.
@freestanding(expression)
public macro binaryString(_ value: Int) -> String = #externalMacro(module: "Macros", type: "BinaryStringMacro")

@attached(member, names: named(sample))
public macro SampleBuilder(
    numberOfItems: Int,
    dataGeneratorType: DataGeneratorType
) = #externalMacro(module: "Macros", type: "SampleBuilderMacro")

@attached(peer)
public macro SampleBuilderItem(
    category: SampleBuilderItemCategory
) = #externalMacro(module: "Macros", type: "SampleBuilderItemMacro")
