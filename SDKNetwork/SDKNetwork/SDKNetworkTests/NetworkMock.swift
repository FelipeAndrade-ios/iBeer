//
//  NetworkMock.swift
//  SDKNetworkTests
//
//  Created by Felipe Andrade on 27/02/21.
//

import Foundation
@testable import SDKNetwork

class NetworkMock: Request {
    
    let error: TestError?
    
    init(_ error: TestError? = nil) {
        self.error = error
    }
    
    func makeRequest(_ service: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completion("{\"name\":\"testName\"}".data(using: .utf8), nil, error)
    }
}

struct NetworkTestModel: Codable {
    var name: String
}

enum TestError: Error {
    case error
}
