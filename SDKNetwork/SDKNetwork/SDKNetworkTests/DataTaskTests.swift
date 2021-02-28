//
//  SDKNetworkTests.swift
//  SDKNetworkTests
//
//  Created by Felipe Andrade on 28/02/21.
//

import XCTest
import SDKCommon
@testable import SDKNetwork

class SDKNetworkTests: XCTestCase {

    func testDataTaskPlain() {
        let dataTask = DataTask.plain()
        let model = DataTask.RequestContent.plain
        
        XCTAssertEqual(dataTask, model)
    }
    
    func testDataTaskBody() {
        let model = NetworkTestModel(name: "body")
        let dataTask = DataTask.httpBody(model.dictionary)
        
        switch dataTask {
        case .httpBody(let requestData):
            let encodedModel = try? JSONDecoder().decode(NetworkTestModel.self, from: requestData)
            XCTAssertEqual(encodedModel?.name, model.name)
        default:
            XCTFail("Failed to set Task Body")
        }
    }
    
    func testDataTaskURL() {
        let model = NetworkTestModel(name: "data")
        let dataTask = DataTask.urlEncoded(model.dictionary)
        
        switch dataTask {
        case .urlEncoded(let url):
            XCTAssertEqual(url, "?name=data&")
        default:
            XCTFail("Failed to set Task URL")
        }
    }
    
    func testDataTaskURLnil() {
        let dataTask = DataTask.urlEncoded(nil)
        
        switch dataTask {
        case .urlEncoded(let url):
            XCTAssertEqual(url, "?")
        default:
            XCTFail("Failed to null Task URL")
        }
    }
    
    func testDataTaskURLandBody() {
        let model = NetworkTestModel(name: "url")
        let dataTask = DataTask.httpAndBody(urlEncoded: model.dictionary, body: model.dictionary)
        
        switch dataTask {
        case .urlandbody(let url, let requestData):
            let encodedModel = try? JSONDecoder().decode(NetworkTestModel.self, from: requestData)
            XCTAssertEqual(encodedModel?.name, model.name)
            XCTAssertEqual(url, "?name=url&")
        default:
            XCTFail("Failed to set Task URL and Body")
        }
    }
    
    func testThrowParseBody() {
        let dataTask = DataTask.httpBody(CodableTestFailue())
        switch dataTask {
        case .httpBody(let data):
            XCTAssertEqual(data, Data())
        default:
            XCTFail("Failed to break parse of body")
        }
    }
    
    func testThrowParseURLandBody() {
        let dataTask = DataTask.httpAndBody(urlEncoded: nil, body: CodableTestFailue())
        switch dataTask {
        case .urlandbody(let url, let data):
            XCTAssertEqual(data, Data())
            XCTAssertEqual(url, "?")
            
        default:
            XCTFail("Failed to break parse of url and body")
        }
    }
}

struct CodableTestFailue: Codable {
    init() {}
    
    init(from decoder: Decoder) throws {
        throw TestError.error
    }
    
    func encode(to encoder: Encoder) throws {
        throw TestError.error
    }
}
