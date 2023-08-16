import SwiftAndTipsMacros
import Foundation

let x = #binaryString(10)

print(x)


//@SampleBuilder(numberOfItems: 3)
//struct Person {
//    let id: UUID
//    let item1: String
//    let item2: Int
//    let item3: Bool
//    let item4: Data
//    let item5: Date
//    let item6: Double
//    let item7: Float
//    let item8: Int8
//    let item9: Int16
//    let item10: Int32
//    let item11: Int64
//    let item12: UInt8
//    let item13: UInt16
//    let item14: UInt32
//    let item15: UInt64
//    let item16: URL
//    let item17: CGPoint
//    let item18: CGFloat
//    let item19: CGRect
//    let item20: CGSize
//    let item21: CGVector
//}
//
@SampleBuilder(numberOfItems: 10)
struct Review {
    let rating: Int
    let time: Date
    let product: Product
}

@SampleBuilder(numberOfItems: 3)
struct Product {
    var price: Int
    var description: String
}


@SampleBuilder(numberOfItems: 3)
struct MyStruct {
    var array: [Product]
    var array2: [Int]
}

//@SampleBuilder(numberOfItems: 3)
//struct Example {
//    let x: Int
//    var y: String
//    
//    static var notAValidStoredProperty: Self {
//        .init(x: 0, y: "Hello World")
//    }
//    
//    var aComputedProperty: String {
//        "Hello"
//    }
//}


//@SampleBuilder(numberOfItems: 3)
//struct Example {
//    let x: Int
//    private var y: String {
//        didSet {
//            print("didSet called")
//        }
//        willSet {
//            print("willSet called")
//        }
//    }
//    static var asd: Self {
//        .init(x: 0, y: "Hello World")
//    }
//    var z: String {
//        get { y }
//    }
//    var w: String {
//        get {
//            y
//        }
//        set {
//            y = newValue
//        }
//    }
//}

@SampleBuilder(numberOfItems: 3)
struct Example {
    let x: Int
    let y: String
}

