//
//  SDKCommonTests.swift
//  SDKCommonTests
//
//  Created by Felipe Andrade on 27/02/21.
//

import XCTest
@testable import SDKCommon

class SDKCommonTests: XCTestCase {

    func testObservable() {
        let exp = expectation(description: "Observable called")
        let testValue = "testValue"
        
        let observable = Observable<TestModel>(TestModel())
        observable.didChange = { value in
            XCTAssertEqual(testValue, value?.name)
            exp.fulfill()
        }
        
        observable.value = TestModel(name: testValue)
        waitForExpectations(timeout: 2)
    }
    
    func testCodableDictionary() {
        let model = TestModel()
        let dictionary = model.dictionary
        
        XCTAssertEqual(dictionary?["name"], model.name)
    }
    
    func testRepository() {
        let repository = LocalRepository<TestModel>()
        let model = TestModel()
        
        repository.saveData(data: model)
        
        XCTAssertEqual(repository.loadData()?.name, model.name)
        
        repository.deleteData()
        XCTAssertNil(repository.loadData())
    }
    
    func testClassName() {
        let stringName = "TestClass"
        let functionName = TestClass.className
        
        XCTAssertEqual(stringName, functionName)
    }
    
}

class TestClass: NSObject {}

struct TestModel: Codable {
    var name = "Default"
}
