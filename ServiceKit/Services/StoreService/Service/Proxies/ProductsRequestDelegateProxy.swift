//
//  ProductsRequestDelegateProxy.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 08/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation
import StoreKit

protocol ProductsRequestDelegate: class {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse)
}

class ProductsRequestDelegateProxy: NSObject, SKProductsRequestDelegate {

    weak var delegate: ProductsRequestDelegate?

    init(_ delegate: ProductsRequestDelegate? = nil) {
        super.init()
        self.delegate = delegate
    }

    // MARK: - SKProductsRequestDelegate

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        delegate?.productsRequest(request, didReceive: response)
    }
}
