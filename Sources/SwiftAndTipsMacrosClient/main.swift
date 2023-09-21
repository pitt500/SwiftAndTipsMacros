import SwiftAndTipsMacros
import Foundation
import DataGenerator

let x = #binaryString(10)

print(x)

@SampleBuilder(numberOfItems: 10, dataGeneratorType: .default)
struct Example {
    let item1: UUID
    let item2: Int
}

for element in Example.sample {
    print(element.item1, element.item2)
}

@SampleBuilder(numberOfItems: 3, dataGeneratorType: .random)
struct Review {
    let rating: Int
    let time: Date
    let product: Product
}

@SampleBuilder(numberOfItems: 3, dataGeneratorType: .random)
struct Product {
    var price: Int
    var description: String
}

@SampleBuilder(numberOfItems: 3, dataGeneratorType: .random)
struct Profile {
    @SampleBuilderItem(category: .firstName)
    let firstName: String
    
    @SampleBuilderItem(category: .lastName)
    let lastName: String
    
    @SampleBuilderItem(category: .image(width: 300, height: 300))
    let profileImage: URL
}

for profile in Profile.sample {
    print(profile.firstName, profile.lastName, profile.profileImage)
}

//@SampleBuilder(numberOfItems: 5)
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
//@SampleBuilder(numberOfItems: 10)
//struct Review {
//    let rating: Int
//    let time: Date
//    let product: Product
//}
//
//@SampleBuilder(numberOfItems: 3)
//struct Product {
//    var price: Int
//    var description: String
//    
////    init(price: Int) {
////        self.price = 0
////        self.description = ""
////    }
//}

//@SampleBuilder(numberOfItems: 3)
//struct Order {
//    var productList: [Product]
//    var address: String
//    var time: Date
//}

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

//@SampleBuilder(numberOfItems: 3)
//struct Product {
//    var price: Int
//    var description: String
//    var dict1: [String: Int]
//    var dict2: [String: [Int]]
//    var dict3: [String: [String: Example]]
//}
//
//@SampleBuilder(numberOfItems: 3)
//struct Example {
//    let x: Int
//    let y: String
//    let myEnum: MyEnum
//}
//
//@SampleBuilder(numberOfItems: 20)
//struct Product {
//    var item1: Int
//    var item2: String
//}
//
//@SampleBuilder(numberOfItems: 6)
//enum MyEnum {
//    indirect case case1(String, Int, String, [String])
//    case case2
//    case case3(String, [Product])
//}


@SampleBuilder(numberOfItems: 6, dataGeneratorType: .random)
enum MyEnum {
    indirect case case1(String, Int, String, [String])
    case case2
    case case3(Product)
    case case4([String: Product])
}
//
//@SampleBuilder(numberOfItems: 6)
//struct Test {
//    var item1: [[Int]: [[String: [String: [Int: [Int: MyEnum]]]]]]
//}






//@SampleBuilder(numberOfItems: 3)
//enum Example {
//    case response(time: Date, name: String, Data)
//}





















