//
//  StoreServiceImpl+BuyRequest.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 08/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation

extension StoreServiceImpl {
    
    struct BuyRequest {
        
        let productIdentifier: String
        let completion: BuyRequestResult
        
        init(_ productIdentifier: String,
             _ completion: @escaping BuyRequestResult) {
            
            self.productIdentifier = productIdentifier
            self.completion = completion
        }
    }
}
