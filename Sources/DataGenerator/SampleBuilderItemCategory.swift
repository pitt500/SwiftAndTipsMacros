/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

//
//  SampleBuilderItemCategory.swift
//
//
//  Created by Pedro Rojas on 28/08/23.
//

import Foundation

public enum SampleBuilderItemCategory {
    case firstName
    case lastName
    case fullName
    case email
    case address
    case appVersion
    case creditCardNumber
    case companyName
    case username
    case price
    case image(width: Int, height: Int)
    case url
}
