//
//  BeerListServiceTests.swift
//  iBeerTests
//
//  Created by Felipe Andrade on 28/02/21.
//

import XCTest
@testable import iBeer

class BeerListServiceTests: XCTestCase {

    var service: BeerListService!
    var mock: TestRequester!
    
    let setup = MockSetup()
    
    override func setUp() {
        service = BeerListService()
        mock = TestRequester()
        service.requester = mock
    }
    
    override func tearDown() {
        service = nil
        mock = nil
    }
    
    func testRequestListSuccess() {
        mock.setMock(data: setup.getMockSucces(), error: nil)
        let exp = expectation(description: "Request success")
        service.getListOfBeers(model: RequestModel(page: 1), completion: { result in
            switch result {
            case .success(let data):
                exp.fulfill()
                XCTAssertEqual(data.first?.name, self.setup.getModel().name)
                XCTAssertEqual(data.first?.id, self.setup.getModel().id)
            case .failure:
                XCTFail("Should not fail")
            }
        })
        waitForExpectations(timeout: TimeInterval.value)
    }
    
    func testRequestListFailure() {
        mock.setMock(data: nil, error: setup.getMockError())
        let exp = expectation(description: "Request error")
        service.getListOfBeers(model: RequestModel(page: 1), completion: { result in
            switch result {
            case .success:
                XCTFail("Should fail")
            case .failure(let error):
                exp.fulfill()
                XCTAssertNotNil(error)
            }
        })
        waitForExpectations(timeout: TimeInterval.value)
    }

}
