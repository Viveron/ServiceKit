//
//  Receipt.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 02/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation

public struct Receipt: Codable {

    public let productIdentifier: String
    public let content: String

    public init(_ productIdentifier: String, _ content: String) {
        self.productIdentifier = productIdentifier
        self.content = content
    }
}
