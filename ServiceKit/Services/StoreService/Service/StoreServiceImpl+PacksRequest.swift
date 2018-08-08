//
//  StoreServiceImpl+PacksRequest.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 08/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation
import StoreKit

extension StoreServiceImpl {
    
    struct PacksRequest {
        
        let request: SKProductsRequest
        let descriptions: [ProductPackDescription]
        let completion: PacksRequestResult
        
        init(_ request: SKProductsRequest,
             _ descriptions: [ProductPackDescription],
             _ completion: @escaping PacksRequestResult) {
            
            self.request = request
            self.descriptions = descriptions
            self.completion = completion
        }
        
        func cancel() {
            request.cancel()
        }
        
        func description(for productIdentifier: String) -> ProductPackDescription? {
            return descriptions.first { (description) -> Bool in
                return description.productIdentifier == productIdentifier
            }
        }
    }
}
