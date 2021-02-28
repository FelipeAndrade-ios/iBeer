//
//  LogTests.swift
//  SDKNetworkTests
//
//  Created by Felipe Andrade on 28/02/21.
//

import XCTest
@testable import SDKNetwork

class LogTests: XCTestCase {
    
    func testLogEnvironmentNetwork() {
        isTesting = true
        
        let request = Requester()
        Log.isMock(request)
        
        isTesting = false
        XCTAssertEqual("Accessing network", try String(contentsOfFile: "file.txt"))
    }
    
    func testLogEnvironmentMock() {
        isTesting = true
        
        let request = NetworkMock()
        Log.isMock(request)
        
        isTesting = false
        XCTAssertEqual("Accessing mock environment", try String(contentsOfFile: "file.txt"))
    }
    
    func testDefaultLogsParseError() {
        isTesting = true
        
        Log.defaultLogs(.parseError)
        
        isTesting = false
        let fileData = (try? String(contentsOfFile: "file.txt")) ?? ""
        XCTAssertTrue(fileData.contains("nil"))
    }
    
    func testDefaultDataIsNull() {
        isTesting = true
        
        Log.defaultLogs(.dataIsNull)
        
        isTesting = false
        XCTAssertEqual("🟡 Response data is null", try String(contentsOfFile: "file.txt"))
    }
    
    func testDefaultLogsRequestFailed() {
        isTesting = true
        
        Log.defaultLogs(.requestFailed)
        
        isTesting = false
        XCTAssertEqual("🔴 Failed to construct request", try String(contentsOfFile: "file.txt"))
    }
}
