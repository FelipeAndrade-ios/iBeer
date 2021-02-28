//
//  Codable+Extensions.swift
//  iBeer
//
//  Created by Felipe Andrade on 25/02/21.
//

import Foundation

public extension Encodable {
    var dictionary: [String: String]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        let dataArray = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
                                .flatMap { $0 as? [String: Any] } ?? [:]
        var finalDictionary: [String: String] = [:]
        for item in dataArray {
            finalDictionary[item.key] = (item.value as AnyObject).description
        }
        return finalDictionary
    }
}
