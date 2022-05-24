//
//  UserDefaultsManager.swift
//  WeatherApp
//
//  Created by Manish Tamta on 24/05/2022.
//

import Foundation

enum UserDefaultsKey: String {
    case tempUnit
}

struct UserDefaultsManager {
    fileprivate let userDefaults = UserDefaults.standard

    static var shared = UserDefaultsManager()
    private init() {}
    
    func saveObject<T>(_ object: T?, key: UserDefaultsKey) {
        guard object != nil else { return }

        userDefaults.set(object, forKey: key.rawValue)
        userDefaults.synchronize()
    }

    func loadObject(forKey key: UserDefaultsKey) -> Any? {
        guard let value = userDefaults.object(forKey: key.rawValue) else {
            return nil
        }
        return value
    }

    func deleteObject(forKey key: UserDefaultsKey) {
        userDefaults.removeObject(forKey: key.rawValue)
        userDefaults.synchronize()
    }

    func checkObject(forKey key: UserDefaultsKey) -> Bool {
        return userDefaults.object(forKey: key.rawValue) != nil
    }

}
