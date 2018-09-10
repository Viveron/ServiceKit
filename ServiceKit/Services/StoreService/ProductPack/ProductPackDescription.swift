//
//  ProductPackDescription.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 06/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation

public struct ProductPackDescription: Codable {

    public let productIdentifier: String
    public let count: UInt

    public init(_ productIdentifier: String, _ count: UInt) {
        self.productIdentifier = productIdentifier
        self.count = count
    }
}
