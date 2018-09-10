//
//  NetworkConnectionService.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 04/09/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation

public protocol NetworkConnectionService {

    var isConnected: Bool { get }
    var status: NetworkConnectionStatus? { get }

    @discardableResult
    func addObserver(_ queue: DispatchQueue?,
                     _ closure: @escaping (_ status: NetworkConnectionStatus?) -> Void) -> NetworkConnectionObserver

    func removeObserver(_ observer: NetworkConnectionObserver)
}
