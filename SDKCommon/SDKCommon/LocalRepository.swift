//
//  LocalRepository.swift
//  iBeer
//
//  Created by Felipe Andrade on 27/02/21.
//

import Foundation

public class LocalRepository<T: Codable> {
    
    public init() {}
    
    let defaults = UserDefaults.standard
    let key = String(describing: T.self)
    
    public func saveData(data: T) {
        defaults.set(try? PropertyListEncoder().encode(data), forKey: key)
    }
    
    public func loadData() -> T? {
        if let data = defaults.value(forKey: key) as? Data {
            return try? PropertyListDecoder().decode(T.self, from: data)
        }
        return nil
    }
    
    public func deleteData() {
        defaults.removeObject(forKey: key)
    }
}
