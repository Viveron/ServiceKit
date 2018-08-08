//
//  StoreServiceImpl.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 03/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation
import StoreKit

open class StoreServiceImpl<Pack: ProductPack>: StoreService {
    
    private var buyLock: NSLock!
    private var buyRequests: [String: BuyRequest]!
    
    private var packsLock: NSLock!
    private var packsRequests: [Int: PacksRequest]!
    
    private var proxyObserver: PaymentTransactionObserverProxy!
    private var proxyDelegate: ProductsRequestDelegateProxy!
    
    public var canBuy: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    init() {
        buyLock = NSLock()
        buyRequests = [:]
        
        packsLock = NSLock()
        packsRequests = [:]
        
        proxyObserver = PaymentTransactionObserverProxy(self)
        proxyDelegate = ProductsRequestDelegateProxy(self)
        
        SKPaymentQueue.default().add(proxyObserver)
    }
    
    public func buy(pack: Pack, _ completion: @escaping BuyRequestResult) throws {
        buyLock.lock()
        defer {
            buyLock.unlock()
        }
        
        let identifier = pack.product.productIdentifier
        
        guard !buyRequests.keys.contains(identifier) else {
            throw StoreServiceError.purchaseTransactionInProgress
        }
        
        buyRequests[identifier] = BuyRequest(identifier, completion)
        
        let payment = SKPayment(product: pack.product)
        SKPaymentQueue.default().add(payment)
    }
    
    @discardableResult
    public func requestPacks(with descriptions: [ProductPackDescription],
                      _ completion: @escaping PacksRequestResult) -> Int? {
        packsLock.lock()
        defer {
            packsLock.unlock()
        }
        
        guard let request = productsRequest(with: descriptions, completion) else {
            return nil
        }
        
        let identifier = request.hashValue
        packsRequests[identifier] = PacksRequest(request, descriptions, completion)
        
        request.delegate = proxyDelegate
        request.start()
        
        return identifier
    }
    
    public func cancelRequest(by identifier: Int) {
        packsLock.lock()
        defer {
            packsLock.unlock()
        }
        
        guard let request = packsRequests.removeValue(forKey: identifier) else {
            return
        }
        
        request.cancel()
    }
    
    // MARK: - Private methods
    
    private func productsRequest(with descriptions: [ProductPackDescription],
                                 _ completion: @escaping PacksRequestResult) -> SKProductsRequest? {
        guard !descriptions.isEmpty else {
            return nil
        }
        
        var identifiers: Set<String> = []
        for description in descriptions {
            identifiers.insert(description.productIdentifier)
        }
        
        return SKProductsRequest(productIdentifiers: identifiers)
    }
    
    private func completePayment(_ transaction: SKPaymentTransaction, success: Bool) {
        buyLock.lock()
        defer {
            buyLock.unlock()
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
        
        var receipt: Receipt? = nil
        let identifier = transaction.payment.productIdentifier
        
        if success, let content = appStoreReceipt()  {
            receipt = Receipt(identifier, content)
        }
        
        if let request = buyRequests.removeValue(forKey: identifier) {
            request.completion(success, receipt)
        }
    }
    
    private func appStoreReceipt() -> String? {
        if let url = Bundle.main.appStoreReceiptURL {
            if let data = try? Data(contentsOf: url) {
                return data.base64EncodedString()
            }
        }
        return nil
    }
}

// MARK: - ProductsRequestDelegate
extension StoreServiceImpl: ProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        packsLock.lock()
        defer {
            packsLock.unlock()
        }
        
        guard let request = packsRequests.removeValue(forKey: request.hashValue) else {
            return
        }
        
        var packs: [Pack] = []
        for product in response.products {
            if let description = request.description(for: product.productIdentifier) {
                packs.append(Pack.init(product, description.count))
            }
        }
        
        request.completion(packs)
    }
}

// MARK: - PaymentTransactionObserver
extension StoreServiceImpl: PaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completePayment(transaction, success: true)
            case .failed:
                completePayment(transaction, success: false)
            default:
                break
            }
        }
    }
}
