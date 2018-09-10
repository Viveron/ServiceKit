//
//  ProductPack.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 02/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation
import StoreKit

public protocol ProductPack {

    var product: SKProduct { get }
    var count: UInt { get }

    init(_ product: SKProduct, _ count: UInt)
}
