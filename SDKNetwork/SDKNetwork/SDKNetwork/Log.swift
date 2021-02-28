//
//  Log.swift
//  SDKNetwork
//
//  Created by Felipe Andrade on 22/02/21.
//

import Foundation

enum DefaultLogs: String {
    case parseError
    case requestFailed
    case dataIsNull
}
var isTesting = false

internal func print(_ string: String) {
    if isTesting {
        let url = URL(fileURLWithPath: "file.txt")
        try? string.write(to: url, atomically: true, encoding: .utf8)
    } else {
        Swift.print(string)
    }
}

class Log {
    static func defaultLogs(_ type: DefaultLogs, error: Error? = nil) {
        switch type {
        case .parseError:
            print("🔴 Parse error")
            print(error.debugDescription)
        case .requestFailed:
            print("🔴 Failed to construct request")
        case .dataIsNull:
            print("🟡 Response data is null")
        }
    }
    
    static func isMock(_ service: Request) {
        if service is Requester {
            print("Accessing network")
        } else {
            print("Accessing mock environment")
        }
    }
    
    static func request(data: Data?, response: URLResponse?, error: Error?) {
        let httpResponse = response as? HTTPURLResponse
        print("###########################################")
        print("🌎 URL: \(response?.url?.absoluteString ?? "")")
        if let statusCode = httpResponse?.statusCode, (200...299).contains(statusCode) {
            print("🟢 \(statusCode)")
        } else {
            print("🔴 \(httpResponse?.statusCode ?? 0)")
        }
        print("\nHeader:")
        Log.logHeader(header: httpResponse?.allHeaderFields)
        let body = data?.prettyPrintedJSONString ?? ""
        print("\nBody:\n\(body)")
    }
    
    private static func logHeader(header: [AnyHashable: Any]?) {
        guard let header = header as? [String: String] else { return }
        var logHeader = "{\n"
        for item in header {
            logHeader += "    \(item.key) : \(item.value)\n"
        }
        logHeader += "}\n"
        print(logHeader)
    }
}

extension Data {
    var prettyPrintedJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        else { return nil }

        return prettyPrintedString
    }
}
