//
//  StoreServiceError.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 08/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation

public enum StoreServiceError: Error {

    /// Purchase operation of specified product til in process
    case purchaseTransactionInProgress
}
