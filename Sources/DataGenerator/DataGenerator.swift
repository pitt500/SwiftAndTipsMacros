//
//  DataGenerator.swift
//
//
//  Created by Pedro Rojas on 23/08/23.
//

import Foundation
import DataCategory
import Fakery

// Keep all method names in lowercase.
public struct DataGenerator {
    public var int: () -> Int
    public var int8: () -> Int8
    public var int16: () -> Int16
    public var int32: () -> Int32
    public var int64: () -> Int64
    public var uint: () -> UInt
    public var uint8: () -> UInt8
    public var uint16: () -> UInt16
    public var uint32: () -> UInt32
    public var uint64: () -> UInt64
    public var float: () -> Float
    public var float32: () -> Float32
    public var float64: () -> Float64
    public var double: () -> Double
    public var string: () -> String
    public var bool: () -> Bool
    public var data: () -> Data
    public var date: () -> Date
    public var uuid: () -> UUID
    public var cgpoint: () -> CGPoint
    public var cgrect: () -> CGRect
    public var cgsize: () -> CGSize
    public var cgvector: () -> CGVector
    public var cgfloat: () -> CGFloat
    public var url: () -> URL
}

public extension DataGenerator {
    static let `default` = Self(
        int: { 0 },
        int8: { 0 },
        int16: { 0 },
        int32: { 0 },
        int64: { 0 },
        uint: { 0 },
        uint8: { 0 },
        uint16: { 0 },
        uint32: { 0 },
        uint64: { 0 },
        float: { 0 },
        float32: { 0 },
        float64: { 0 },
        double: { 0 },
        string: { "Hello World" },
        bool: { true },
        data: { Data() },
        date: { Date(timeIntervalSinceReferenceDate: 0) },
        uuid: { UUID.increasingUUID },
        cgpoint: { .zero },
        cgrect: { .zero },
        cgsize: { .zero },
        cgvector: { .zero },
        cgfloat: { .zero },
        url: { URL(string: "https://www.apple.com")! }
    )
    static func random(dataCategory: DataCategory? = nil) -> Self {
        Self(
            int: { Faker().number.randomInt() },
            int8: { Int8(Faker().number.randomInt(min: 0, max: Int(Int8.max))) },
            int16: { Int16(Faker().number.randomInt(min: 0, max: Int(Int16.max))) },
            int32: { Int32(Faker().number.randomInt(min: 0, max: Int(Int32.max))) },
            int64: { Int64(Faker().number.randomInt(min: 0, max: Int(Int64.max))) },
            uint: { UInt(Faker().number.randomInt()) },
            uint8: { UInt8(Faker().number.randomInt(min: 0, max: Int(UInt8.max))) },
            uint16: { UInt16(Faker().number.randomInt(min: 0, max: Int(UInt16.max))) },
            uint32: { UInt32(Faker().number.randomInt()) },
            uint64: { UInt64(Faker().number.randomInt()) },
            float: { Faker().number.randomFloat() },
            float32: { Float32(Faker().number.randomFloat()) },
            float64: { Float64(Faker().number.randomFloat()) },
            double: {
                guard case .builtInValue(let value) = dataCategory?.category
                else {
                    return Faker().number.randomDouble()
                }
                
                return value == .price ? Faker().commerce.price() : Faker().number.randomDouble()
            },
            string: {
                let stringCollection: [String] = [
                    Faker().name.firstName(),
                    Faker().name.lastName(),
                    Faker().name.name(),
                    Faker().internet.email(),
                    "\(Faker().address.streetAddress(includeSecondary: true)), \(Faker().address.city()), \(Faker().address.stateAbbreviation()) \(Faker().address.postcode())",
                    Faker().app.version(),
                    Faker().business.creditCardNumber(),
                    Faker().company.name(),
                    Faker().internet.username()
                ]
                
                guard case .builtInValue(let value) = dataCategory?.category
                else {
                    return stringCollection.randomElement()!
                }
                
                return switch value {
                case .firstName:
                    Faker().name.firstName()
                case .lastName:
                    Faker().name.lastName()
                case .fullName:
                    Faker().name.name()
                case .email:
                    Faker().internet.email()
                case .address:
                    "\(Faker().address.streetAddress(includeSecondary: true)), \(Faker().address.city()), \(Faker().address.stateAbbreviation()) \(Faker().address.postcode())"
                case .appVersion:
                    Faker().app.version()
                case .creditCardNumber:
                    Faker().business.creditCardNumber()
                case .companyName:
                    Faker().company.name()
                case .username:
                    Faker().internet.username()
                case .url, .price:
                    stringCollection.randomElement()!
                }
            },
            bool: { Faker().number.randomBool() },
            data: { Data() },
            date: { Faker.Date().backward(days: Faker().number.randomInt(min: 0, max: 100)) },
            uuid: { UUID() },
            cgpoint: { CGPoint() },
            cgrect: { CGRect() },
            cgsize: { CGSize() },
            cgvector: { CGVector() },
            cgfloat: { CGFloat() },
            url: {
                guard case .image(let width, let height) = dataCategory?.category
                else {
                    return URL(string: Faker().internet.url())!
                }
                
                return URL(string: "https://picsum.photos/\(width)/\(height)")!
            }
        )
    }
}

public extension UUID {
    static var uuIdCounter: UInt = 0

    static var increasingUUID: UUID {
        defer {
            uuIdCounter += 1
        }
        return UUID(uuidString: "00000000-0000-0000-0000-\(String(format: "%012x", uuIdCounter))")!
    }
}

public enum DataGeneratorType: String {
    case `default`
    case random
}
