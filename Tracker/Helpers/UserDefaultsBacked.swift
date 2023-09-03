//
//  UserDefaultsBacked.swift
//  Tracker
//
//  Created by Игорь Полунин on 29.08.2023.
//

import Foundation

@propertyWrapper
struct UserDefaultsBacked<Value> {
    let key: String
    let storage: UserDefaults = .standard
    
    var wrappedValue: Value? {
        get {
            storage.value(forKey: key) as? Value
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}
