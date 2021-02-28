//
//  ServiceTests.swift
//  SDKNetworkTests
//
//  Created by Felipe Andrade on 27/02/21.
//

import XCTest
import SDKCommon
@testable import SDKNetwork

class ServiceTests: XCTestCase {

    var service: Service<TestServiceStructure>!
    
    override func setUp() {
        service = Service<TestServiceStructure>()
        service.requester = NetworkMock()
    }
    
    override func tearDown() {
        service = nil
    }
    
    func testMockModelSucess() {
        let exp = expectation(description: "Mock success with model")
        
        service.request(.any, model: NetworkTestModel.self) { (result, _) in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.name, "testName")
            case .failure:
                XCTFail("Failed to mock model")
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testMockModelFailureParse() {
        let exp = expectation(description: "Mock failure with model")
        
        service.request(.any, model: WrongModel.self) { (result, _) in
            switch result {
            case .success:
                XCTFail("Should not be success")
            case .failure(let error):
                if case .parseError = error {
                    XCTAssertNotNil(error)
                } else {
                    XCTFail("Must be parse Error")
                }
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testMockModelFailureServer() {
        let exp = expectation(description: "Mock failure with model")
        service.requester = NetworkMock(.error)
        service.request(.any, model: NetworkTestModel.self) { (result, _) in
            switch result {
            case .success:
                XCTFail("Should not be success")
            case .failure(let error):
                if case .serverError = error {
                    XCTAssertNotNil(error)
                } else {
                    XCTFail("Must be server Error")
                }
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testMockDataSuccess() {
        let exp = expectation(description: "Mock success with data")
        
        service.request(.any) { (result, _) in
            switch result {
            case .success(let data):
                if let data = data {
                    let model = try? JSONDecoder().decode(NetworkTestModel.self, from: data)
                    XCTAssertEqual(model?.name, "testName")
                } else {
                    XCTFail("Data must not be null")
                }
            case .failure:
                XCTFail("Should not fail")
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testMockDataFailure() {
        let exp = expectation(description: "Mock failure with data")
        service.requester = NetworkMock(.error)
        service.request(.any) { (result, _) in
            switch result {
            case .success:
                XCTFail("Should not be success")
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testNetworkErrorWithModel() {
        let exp = expectation(description: "Mock failure with network error in model")
        let service = Service<TestServiceNetworkError>()
        service.requester = NetworkMock(.error)
        
        service.request(.any, model: WrongModel.self) { (result, _) in
            switch result {
            case .success:
                XCTFail("Should not be success")
            case .failure(let error):
                if case .network = error {
                    XCTAssertNotNil(error)
                } else {
                    XCTFail("Must be network error")
                }
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testNetworkErrorWithData() {
        let exp = expectation(description: "Mock failure with network error in data")
        let service = Service<TestServiceNetworkError>()
        service.requester = NetworkMock(.error)
        
        service.request(.any) { (result, _) in
            switch result {
            case .success:
                XCTFail("Should not be success")
            case .failure(let error):
                if case .network = error {
                    XCTAssertNotNil(error)
                } else {
                    XCTFail("Must be network error")
                }
            }
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 2)
    }
    
    func testSetEnvironmentHttpBodyAndDecode() {
        let service = Service<TestHttpBody>()
        
        enum TestHttpBody: ServiceRequest {
            case any(NetworkTestModel)
            
            var url: String { return "anyUrl" }
            var httpMethod: HTTPMethod { return .get}
            var header: [String: String]? { return nil }
            var data: DataTask.RequestContent {
                switch self {
                case .any(let data):
                    return DataTask.httpBody(data)
                }
            }
        }
        let flow: TestHttpBody = .any(NetworkTestModel(name: "httpBody"))
        guard let data = service.setupEnvirnment(flow)?.httpBody else {
            XCTFail("Data must not be null")
            return
        }
        let model = service.decodeBody(data: data, model: NetworkTestModel.self)
        
        XCTAssertEqual(model?.name, NetworkTestModel(name: "httpBody").name)
    }
    
    func testSetEnvironmentURLEncoded() {
        let service = Service<TestHttpBody>()
        
        enum TestHttpBody: ServiceRequest {
            case any(NetworkTestModel)
            
            var url: String { return "anyUrl" }
            var httpMethod: HTTPMethod { return .get}
            var header: [String: String]? { return nil }
            var data: DataTask.RequestContent {
                switch self {
                case .any(let data):
                    return DataTask.urlEncoded(data.dictionary)
                }
            }
        }
        let flow: TestHttpBody = .any(NetworkTestModel(name: "urlEncoded"))
        guard let url = service.setupEnvirnment(flow)?.url?.absoluteString else {
            XCTFail("url must not be null")
            return
        }
        
        XCTAssertEqual("\(flow.url)?name=urlEncoded&", url)
    }
    
    func testSetEnvironmentURLEncodedAndBody() {
        let service = Service<TestHttpBody>()
        
        enum TestHttpBody: ServiceRequest {
            case any(NetworkTestModel)
            
            var url: String { return "anyUrl" }
            var httpMethod: HTTPMethod { return .get}
            var header: [String: String]? { return nil }
            var data: DataTask.RequestContent {
                switch self {
                case .any(let data):
                    return DataTask.httpAndBody(urlEncoded: data.dictionary, body: data)
                }
            }
        }
        let flow: TestHttpBody = .any(NetworkTestModel(name: "httpBodyAndUrlEncoded"))
        guard let environment = service.setupEnvirnment(flow),
              let url = environment.url?.absoluteString,
              let data = environment.httpBody else {
            XCTFail("The service needs all data")
            return
        }
        
        let model = service.decodeBody(data: data, model: NetworkTestModel.self)
        
        XCTAssertEqual(model?.name, NetworkTestModel(name: "httpBodyAndUrlEncoded").name)
        XCTAssertEqual("\(flow.url)?name=httpBodyAndUrlEncoded&", url)
    }
    
    func testFailedParseDataNull() {
        let model = service.decodeBody(data: nil, model: NetworkTestModel.self)
        XCTAssertNil(model)
    }
    
    func testFailedParseError() {
        let model = try? JSONEncoder().encode(WrongModel(test: ""))
        XCTAssertNotNil(model)
        let decodedModel = service.decodeBody(data: model, model: NetworkTestModel.self)
        XCTAssertNil(decodedModel)
    }
    
    func testParseSuccess() {
        let model = NetworkTestModel(name: "")
        let data = try? JSONEncoder().encode(model)
        XCTAssertNotNil(model)
        let decodedModel = service.decodeBody(data: data, model: NetworkTestModel.self)
        XCTAssertEqual(decodedModel?.name, model.name)
    }
    
}

enum TestServiceStructure: ServiceRequest {
    case any
    
    var url: String { return "fakeUrl" }
    var httpMethod: HTTPMethod { return .get }
    var header: [String: String]? { return ["test": "testing"] }
    var data: DataTask.RequestContent { return .plain }
}

enum TestServiceNetworkError: ServiceRequest {
    case any
    
    var url: String { return "" }
    var httpMethod: HTTPMethod { return .get }
    var header: [String: String]? { return nil }
    var data: DataTask.RequestContent { return .plain }
}

struct WrongModel: Codable {
    var test: String
}
