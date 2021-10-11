//
//  Store.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import Foundation

typealias Subscription = NSObjectProtocol

class Store {
    
    // MARK: Variable
    private enum NotificationName {
        static let storeChanged = Notification.Name("store-changed")
    }
    
    private lazy var dispatchToken: DispatchToken = {
        return dispatcher.register(callback: { [weak self] action in
            self?.onDispatch(action)
        })
    }()
    
    private let dispatcher: Dispatcher
    private let notificationCenter: NotificationCenter
    
    
    // MARK: Initialize
    init(dispatcher: Dispatcher) {
        self.dispatcher = dispatcher
        self.notificationCenter = NotificationCenter()
        _ = dispatchToken
    }
    
    deinit {
        dispatcher.unregister(dispatchToken)
    }
    
    func onDispatch(_ action: Action) {
        fatalError("must override")
    }
    
    final func emitChange() {
        notificationCenter.post(name: NotificationName.storeChanged, object: nil)
    }
    
    final func addListener(callback: @escaping () -> ()) -> Subscription {
        let using: (Notification) -> () = { notification in
            if notification.name == NotificationName.storeChanged {
                callback()
            }
        }
        return notificationCenter.addObserver(forName: NotificationName.storeChanged,
                                              object: nil,
                                              queue: nil,
                                              using: using)
    }
    
    final func removeListener(_ subscription: Subscription) {
        notificationCenter.removeObserver(subscription)
    }
}
