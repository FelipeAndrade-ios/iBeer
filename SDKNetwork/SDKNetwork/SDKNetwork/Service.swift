//
//  Test.swift
//  SDKNetwork
//
//  Created by Felipe Andrade on 22/02/21.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

public enum Timeout: TimeInterval {
    case short = 15
    case medium = 30
    case long = 60
}

public enum RequestError: Error {
    case network
    case serverError(Error)
    case parseError
    case unknown
}

public protocol ServiceRequest {
    var url: String { get }
    var httpMethod: HTTPMethod { get }
    var header: [String: String]? { get }
    var data: DataTask.RequestContent { get }
}

open class Service<U: ServiceRequest> {
    var requester: Request = Requester()
    
    var timeout = Timeout.medium
    
    public init() {}
    
    public func request<T: Codable>(_ flow: U,
                                    model: T.Type,
                                    completion: @escaping (Result<T, RequestError>, URLResponse?) -> Void) {
        guard let service = setupEnvirnment(flow) else {
            completion(.failure(.network), nil)
            return
        }
        Log.isMock(requester)
        requester.makeRequest(service) { (data, response, error) in
            Log.request(data: data, response: response, error: error)
            if let error = error {
                completion(.failure(.serverError(error)), response)
            } else if let model = self.decodeBody(data: data, model: model) {
                completion(.success(model), response)
            } else {
                completion(.failure(.parseError), response)
            }
        }
    }
    
    public func request(_ flow: U, completion: @escaping (Result<Data?, RequestError>, URLResponse?) -> Void) {
        guard let service = setupEnvirnment(flow) else {
            completion(.failure(.network), nil)
            return
        }
        Log.isMock(requester)
        requester.makeRequest(service) { data, response, error in
            Log.request(data: data, response: response, error: error)
            if let error = error {
                completion(.failure(.serverError(error)), response)
            } else {
                completion(.success(data), response)
            }
        }
    }
    
    func setupEnvirnment(_ flow: U) -> URLRequest? {
        if let url = URL(string: flow.url) {
            
            var service = URLRequest(url: url)
            service.timeoutInterval = timeout.rawValue
            service.httpMethod = flow.httpMethod.rawValue
            service.allHTTPHeaderFields = flow.header
            switch flow.data {
            case .httpBody(let data):
                service.httpBody = data
            case .urlandbody(let url, let body):
                service.url = URL(string: "\(service.url?.absoluteString ?? "")\(url)")
                service.httpBody = body
            case .urlEncoded(let url):
                service.url = URL(string: "\(service.url?.absoluteString ?? "")\(url)")
            default: break
            }
            return service
        } else {
            Log.defaultLogs(.requestFailed)
            return nil
        }
    }
    
    func decodeBody<T: Codable>(data: Data?, model: T.Type) -> T? {
        if let data = data {
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                return model
            } catch {
                Log.defaultLogs(.parseError, error: error)
                return nil
            }
        } else {
            Log.defaultLogs(.dataIsNull)
            return nil
        }
    }
}
