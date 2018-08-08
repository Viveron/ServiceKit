//
//  ProductPackDescription.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 06/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation

struct ProductPackDescription: Codable {
    
    let productIdentifier: String
    let count: UInt
    
    init(_ productIdentifier: String, _ count: UInt) {
        self.productIdentifier = productIdentifier
        self.count = count
    }
}
