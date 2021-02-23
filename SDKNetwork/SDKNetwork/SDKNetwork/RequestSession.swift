//
//  RequestSession.swift
//  SDKNetwork
//
//  Created by Felipe Andrade on 22/02/21.
//

import Foundation

public protocol Request {
    func makeRequest(_ service: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class Requester: Request {
    func makeRequest(_ service: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: service, completionHandler: completion).resume()
    }
}
