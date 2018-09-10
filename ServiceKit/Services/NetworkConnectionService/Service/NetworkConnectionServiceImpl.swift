//
//  NetworkConnectionServiceImpl.swift
//  ServiceKit
//
//  Created by Victor Shabanov on 05/09/2018.
//  Copyright © 2018 Victor Shabanov. All rights reserved.
//

import Foundation
import SystemConfiguration

open class NetworkConnectionServiceImpl {

    private let queue = DispatchQueue.main
    private let lock = NSLock()

    private let reachability: SCNetworkReachability?
    private var flags = SCNetworkReachabilityFlags()

    private var observers: [NetworkConnectionObserver] = []
    private var _status: NetworkConnectionStatus? {
        didSet {
            perform {
                self.notifyObservers(self._status)
            }
        }
    }

    public init(host: String) {
        self.reachability = SCNetworkReachabilityCreateWithName(nil, host)

        startConnectionObserving()
    }

    deinit {
        stopConnectionObserving()
    }

    // MARK: - Private methods

    private func startConnectionObserving() {
        guard reachability != nil else {
            return
        }

        var context = SCNetworkReachabilityContext.injectedInfo(self)
        _ = SCNetworkReachabilitySetCallback(reachability!, { (_, flags, info) in
            guard info != nil else {
                return
            }
            Unmanaged<NetworkConnectionServiceImpl>.fromOpaque(info!).takeUnretainedValue().updateStatus(flags)
        }, &context)

        _ = SCNetworkReachabilitySetDispatchQueue(reachability!, queue)
        queue.async { [unowned self] in
            self.updateStatus(self.obtainFlags() ?? self.flags)
        }
    }

    private func stopConnectionObserving() {
        if reachability != nil {
            SCNetworkReachabilitySetCallback(reachability!, nil, nil)
            SCNetworkReachabilitySetDispatchQueue(reachability!, nil)
        }
    }

    private func obtainFlags() -> SCNetworkReachabilityFlags? {
        var flags = SCNetworkReachabilityFlags()
        guard reachability != nil, SCNetworkReachabilityGetFlags(reachability!, &flags) else {
            return nil
        }

        return flags
    }

    private func updateStatus(_ flags: SCNetworkReachabilityFlags) {
        guard self.flags != flags else {
            return
        }
        self.flags = flags

        var connectionStatus = NetworkConnectionStatus.disconnected
        if flags.isNetworkReachable {
            var connectionType = NetworkConnectionType.wifi

            if flags.contains(.isWWAN) {
                connectionType = .wwan
            }

            connectionStatus = .connected(connectionType)
        }

        _status = connectionStatus
    }

    // MARK: - Observers methods

    private func notifyObservers(_ status: NetworkConnectionStatus?) {
        for observer in observers {
            observer.queue.async {
                observer.update(status)
            }
        }
    }

    // MARK: - Synchronization helpers

    private func perform(_ closure: @escaping () -> Void) {
        queue.async {
            self.performAndWait(closure)
        }
    }

    private func performAndWait(_ closure: @escaping () -> Void) {
        lock.lock()
        defer {
            lock.unlock()
        }

        closure()
    }
}

// MARK: - NetworkConnectionService
extension NetworkConnectionServiceImpl: NetworkConnectionService {

    public var isConnected: Bool {
        if let status = status, case .connected = status {
            return true
        }
        return false
    }

    public var status: NetworkConnectionStatus? {
        return _status
    }

    @discardableResult
    public func addObserver(_ queue: DispatchQueue?,
                            _ closure: @escaping (_ status: NetworkConnectionStatus?) -> Void) -> NetworkConnectionObserver {
        let observer = NetworkConnectionObserver(queue, closure)
        performAndWait {
            self.observers.append(observer)
        }

        observer.update(status)
        return observer
    }

    public func removeObserver(_ observer: NetworkConnectionObserver) {
        performAndWait {
            if let index = self.observers.index(of: observer) {
                self.observers.remove(at: index)
            }
        }
    }
}

// MARK: - Helpers

fileprivate extension SCNetworkReachabilityFlags {

    var isNetworkReachable: Bool {
        let isReachable = contains(.reachable)
        let needsConnection = contains(.connectionRequired)
        let canConnectAutomatically = contains(.connectionOnDemand) || contains(.connectionOnTraffic)
        let canConnectWithoutUserInteraction = canConnectAutomatically && !contains(.interventionRequired)

        return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
    }
}

fileprivate extension SCNetworkReachabilityContext {

    static func injectedInfo(_ target: AnyObject) -> SCNetworkReachabilityContext {
        var context = SCNetworkReachabilityContext(version: 0,
                                                   info: nil,
                                                   retain: nil,
                                                   release: nil,
                                                   copyDescription: nil)

        context.info = Unmanaged.passUnretained(target).toOpaque()
        return context
    }
}
