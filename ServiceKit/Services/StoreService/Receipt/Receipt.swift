//
//  Receipt.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 02/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation

struct Receipt: Codable {
    
    let productIdentifier: String
    let content: String
    
    init(_ productIdentifier: String, _ content: String) {
        self.productIdentifier = productIdentifier
        self.content = content
    }
}
