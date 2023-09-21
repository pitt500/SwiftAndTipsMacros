/*
 This source file is part of SwiftAndTipsMacros

 Copyright (c) 2023 Pedro Rojas and project authors
 Licensed under MIT License
*/

//
//  SampleBuilderFixIt.swift
//  
//
//  Created by Pedro Rojas on 22/08/23.
//

import SwiftDiagnostics

struct SampleBuilderFixIt: FixItMessage {
    public let message: String
    private let messageID: String

    /// This should only be called within a static var on FixItMessage, such
    /// as the examples below. This allows us to pick up the messageID from the
    /// var name.
    fileprivate init(_ message: String, messageID: String = #function) {
      self.message = message
      self.messageID = messageID
    }

    public var fixItID: MessageID {
      MessageID(
        domain: "SwiftAndTipsMacros",
        id: "\(type(of: self)).\(messageID)"
      )
    }
}


extension FixItMessage where Self == SampleBuilderFixIt {
    static var addNewEnumCase: Self {
      .init("add a new enum case")
    }
    
    static var removeSampleBuilderItem: Self {
      .init("remove @SampleBuilderItem")
    }
}
