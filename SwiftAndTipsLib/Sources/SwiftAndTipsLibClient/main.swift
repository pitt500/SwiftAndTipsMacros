import SwiftAndTipsLib

let x = #binaryString(10)

print(x)

@SampleBuilder(numberOfItems: 3)
struct Person {
    let name: String
    let age: Int
}
