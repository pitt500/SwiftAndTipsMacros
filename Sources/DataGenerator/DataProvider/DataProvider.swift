/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

//
//  DataProvider.swift
//
//
//  Created by Pedro Rojas on 15/09/23.
//

import Foundation

protocol StringDataProvider {
    func firstName() -> String
    func lastName() -> String
    func fullName() -> String
    func email() -> String
    func address() -> String
    func appVersion() -> String
    func username() -> String
    func creditCardNumber() -> String
    func companyName() -> String
}

protocol BooleanDataProvider {
    func randomBool() -> Bool
}

protocol DateDataProvider {
    func date() -> Date
}

protocol URLDataProvider {
    func url() -> URL
    func image(width: Int, height: Int) -> URL
}

protocol NumericDataProvider {
    func randomInt(min: Int, max: Int) -> Int
    func randomFloat(min: Float, max: Float) -> Float
    func randomDouble(min: Double, max: Double) -> Double
    func price() -> Double
}
