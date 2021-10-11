//
//  LocalCacheKey.swift
//  Swift-Introduction-to-iOS-design-patterns-Flux
//
//  Created by kazunori.aoki on 2021/10/11.
//

import Foundation
import GitHub

protocol LocalCacheKeys {}

struct LocalCacheKey<Value: LocalCacheValue>: LocalCacheKeys {
    let rawValue: String
    let defaultValue: Value
    
    fileprivate init(_ rawValue: String, defaultValue: Value) {
        self.rawValue = rawValue
        self.defaultValue = defaultValue
    }
}

extension LocalCacheKeys {
    static var favorites: LocalCacheKey<[GitHub.Repository]> {
        return LocalCacheKey("favorites", defaultValue: [])
    }
}

extension GitHub.Repository: LocalCacheValue {}
