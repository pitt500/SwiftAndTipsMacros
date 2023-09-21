/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

//
//  DataGenerator.swift
//
//
//  Created by Pedro Rojas on 23/08/23.
//

import Foundation
import DataCategory

fileprivate typealias Provider = FakeDataProvider

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
        cgpoint: { CGPoint() },
        cgrect: { CGRect() },
        cgsize: { CGSize() },
        cgvector: { CGVector() },
        cgfloat: { CGFloat() },
        url: { URL(string: "https://www.apple.com")! }
    )
    static func random(dataCategory: DataCategory? = nil) -> Self {
        Self(
            int: { Provider().randomInt(min: 0, max: 1000) },
            int8: { Int8(Provider().randomInt(min: 0, max: 1000)) },
            int16: { Int16(Provider().randomInt(min: 0, max: 1000)) },
            int32: { Int32(Provider().randomInt(min: 0, max: 1000)) },
            int64: { Int64(Provider().randomInt(min: 0, max: 1000)) },
            uint: { UInt(Provider().randomInt(min: 0, max: 1000) ) },
            uint8: { UInt8(Provider().randomInt(min: 0, max: 1000)) },
            uint16: { UInt16(Provider().randomInt(min: 0, max: 1000)) },
            uint32: { UInt32(Provider().randomInt(min: 0, max: 1000)) },
            uint64: { UInt64(Provider().randomInt(min: 0, max: 1000)) },
            float: { Provider().randomFloat(min: 0, max: 1000) },
            float32: { Float32(Provider().randomFloat(min: 0, max: 1000)) },
            float64: { Float64(Provider().randomFloat(min: 0, max: 1000)) },
            double: {
                guard case .builtInValue(let value) = dataCategory?.category
                else {
                    return Provider().randomDouble(min: 0, max: 1000)
                }
                
                return if value == .price {
                    Provider().price()
                } else {
                    Provider().randomDouble(min: 0, max: 1000)
                }
            },
            string: {
                let stringCollection: [String] = [
                    Provider().firstName(),
                    Provider().lastName(),
                    Provider().fullName(),
                    Provider().email(),
                    Provider().address(),
                    Provider().appVersion(),
                    Provider().creditCardNumber(),
                    Provider().companyName(),
                    Provider().username()
                ]
                
                guard case .builtInValue(let value) = dataCategory?.category
                else {
                    return stringCollection.randomElement()!
                }
                
                return switch value {
                case .firstName:
                    Provider().firstName()
                case .lastName:
                    Provider().lastName()
                case .fullName:
                    Provider().fullName()
                case .email:
                    Provider().email()
                case .address:
                    Provider().address()
                case .appVersion:
                    Provider().appVersion()
                case .creditCardNumber:
                    Provider().creditCardNumber()
                case .companyName:
                    Provider().companyName()
                case .username:
                    Provider().username()
                case .url, .price:
                    stringCollection.randomElement()!
                }
            },
            bool: { Provider().randomBool() },
            data: { Data() },
            date: { Provider().date() },
            uuid: { UUID() },
            cgpoint: { CGPoint() },
            cgrect: { CGRect() },
            cgsize: { CGSize() },
            cgvector: { CGVector() },
            cgfloat: { CGFloat() },
            url: {
                guard case .image(let width, let height) = dataCategory?.category
                else {
                    return Provider().url()
                }
                
                return Provider().image(width: width, height: height)
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
