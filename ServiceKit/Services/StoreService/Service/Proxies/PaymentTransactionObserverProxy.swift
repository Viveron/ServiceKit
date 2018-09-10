//
//  PaymentTransactionObserverProxy.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 08/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation
import StoreKit

protocol PaymentTransactionObserver: class {

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])
}

class PaymentTransactionObserverProxy: NSObject, SKPaymentTransactionObserver {

    weak var observer: PaymentTransactionObserver?

    init(_ observer: PaymentTransactionObserver? = nil) {
        super.init()
        self.observer = observer
    }

    // MARK: - SKPaymentTransactionObserver

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        observer?.paymentQueue(queue, updatedTransactions: transactions)
    }
}
