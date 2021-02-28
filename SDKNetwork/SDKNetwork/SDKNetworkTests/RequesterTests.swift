//
//  RequesterTests.swift
//  SDKNetworkTests
//
//  Created by Felipe Andrade on 28/02/21.
//

import XCTest
@testable import SDKNetwork

class RequesterTests: XCTestCase {

    func testRequesterSuccess() {
        let exp = expectation(description: "calling google")
        let requester = Requester()
        var service = URLRequest(url: URL(string: "https://google.com") ?? URL(fileURLWithPath: ""))
        service.timeoutInterval = 2
        
        requester.makeRequest(service) { (data, response, error) in
            XCTAssertNotNil(data)
            XCTAssertNotNil(response)
            XCTAssertNil(error)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }

    func testRequesterFailure() {
        let exp = expectation(description: "calling google")
        let requester = Requester()
        var service = URLRequest(url: URL(string: "https://none.w.z") ?? URL(fileURLWithPath: ""))
        service.timeoutInterval = 2
        
        requester.makeRequest(service) { (data, response, error) in
            XCTAssertNil(data)
            XCTAssertNil(response)
            XCTAssertNotNil(error)
            exp.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
}
