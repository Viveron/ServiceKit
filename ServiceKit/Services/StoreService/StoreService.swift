//
//  StoreService.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 02/08/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation

public protocol StoreService: class {
    associatedtype Pack: ProductPack

    typealias BuyRequestResult = (_ success: Bool, _ receipt: Receipt?) -> Void
    typealias PacksRequestResult = (_ packs: [Pack]) -> Void

    var canBuy: Bool { get }

    func buy(pack: Pack, _ completion: @escaping BuyRequestResult) throws

    @discardableResult
    func requestPacks(with descriptions: [ProductPackDescription],
                      _ completion: @escaping PacksRequestResult) -> Int?

    func cancelRequest(by identifier: Int)
}
