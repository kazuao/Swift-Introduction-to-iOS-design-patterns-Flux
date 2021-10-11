//
//  Dispatcher.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import Foundation

typealias DispatchToken = String

final class Dispatcher {
    
    static let shared = Dispatcher()
    
    let lock: NSLocking
    private var callbacks: [DispatchToken: (Action) -> ()]
    
    init() {
        self.lock = NSRecursiveLock()
        self.callbacks = [:]
    }
    
    func register(callback: @escaping (Action) -> ()) -> DispatchToken {
        lock.lock(); defer { lock.unlock() }
        
        let token = UUID().uuidString
        callbacks[token] = callback
        return token
    }
    
    func unregister(_ token: DispatchToken) {
        lock.lock(); defer { lock.unlock() }
        
        callbacks.removeValue(forKey: token)
    }
    
    func dispatch(_ action: Action) {
        lock.lock(); defer { lock.unlock() }
        
        callbacks.forEach { _, callback in
            callback(action)
        }
    }
}
