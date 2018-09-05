//
//  NetworkConnectionStatus.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 04/09/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation

public enum NetworkConnectionStatus: Equatable {
    case disconnected
    case connected(NetworkConnectionType)
    
    var isConnected: Bool {
        if case .connected = self {
            return true
        }
        return false
    }
    
    func isConnected(by: NetworkConnectionType) -> Bool {
        if case let .connected(type) = self {
            return by == type
        }
        return false
    }
}

public enum NetworkConnectionType: Equatable {
    case wifi
    case wwan
}
