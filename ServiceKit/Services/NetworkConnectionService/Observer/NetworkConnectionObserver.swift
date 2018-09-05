//
//  NetworkConnectionObserver.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 04/09/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation

open class NetworkConnectionObserver: NSObject {
    
    internal let queue: DispatchQueue
    internal let update: (_ status: NetworkConnectionStatus?) -> Void
    
    internal init(_ queue: DispatchQueue?,
                  _ closure: @escaping (_ status: NetworkConnectionStatus?) -> Void) {
        self.update = closure
        self.queue = queue ?? .main
    }
}
