//
//  DataTask.swift
//  SDKNetwork
//
//  Created by Felipe Andrade on 22/02/21.
//

import Foundation

public struct DataTask {
    public enum RequestContent {
        case httpBody(Data)
        case urlEncoded(String)
        case urlandbody(String, Data)
        case plain
    }

    public static func urlEncoded(_ data: [String: Any]?) -> RequestContent {
        var finalString = "?"
        for index in data ?? [:] {
            let parameter = index.key + "=" + (index.value as? String ?? "") + "&"
            finalString.append(contentsOf: parameter
                                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        
        return .urlEncoded(finalString)
    }

    public static func httpBody<T: Encodable>(_ data: T) -> RequestContent {
        let jsonEncoder = JSONEncoder()
        do {
            return try .httpBody(jsonEncoder.encode(data))
        } catch {
            Log.defaultLogs(.parseError)
            return .httpBody(Data())
        }
    }

    public static func httpAndBody<T: Encodable>(urlEncoded: [String: Any]?, body: T) -> RequestContent {
        var finalString = "?"
        for index in urlEncoded ?? [:] {
            let parameter = index.key + "=" + (index.value as? String ?? "") + "&"
            finalString.append(contentsOf: parameter)
        }
        
        let jsonEncoder = JSONEncoder()
        do {
            return try .urlandbody(finalString, jsonEncoder.encode(body))
        } catch {
            Log.defaultLogs(.parseError)
            return .urlandbody(finalString, Data())
        }
    }
    
    public static func plain() -> RequestContent {
        return .plain
    }
}

// For Tests
extension DataTask.RequestContent: Equatable { }
