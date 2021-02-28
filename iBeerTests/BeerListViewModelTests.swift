//
//  BeerListViewModelTests.swift
//  iBeerTests
//
//  Created by Felipe Andrade on 28/02/21.
//

import XCTest
import SDKNetwork
@testable import iBeer

class BeerListViewModelTests: XCTestCase {

    var viewModel: BeerListViewModel!
    var mock: TestRequester!
    let setup = MockSetup()
    
    var beerDetails = false
    
    override func setUp() {
        viewModel = BeerListViewModel()
        mock = TestRequester()
        viewModel?.service.requester = mock
    }
    
    override func tearDown() {
        viewModel.repository.deleteData()
        CoreData.shared.deleteAllData()
        viewModel = nil
        mock = nil
        beerDetails = false
    }
    
    func testGetListOfBeersSuccess() {
        MainData.staticToggleForUserDefaults = true
        viewModel.repository.deleteData()
        
        mock.setMock(data: setup.getMockSucces(), error: nil)
        let exp = expectation(description: "first page list success")
        viewModel.requestObervable.didChange = { value in
            XCTAssertEqual(value?.count, 1)
            XCTAssertEqual(value?.first?.name, self.setup.getModel().name)
            XCTAssertEqual(value?.first?.id, self.setup.getModel().id)
            exp.fulfill()
        }
        
        viewModel.getListOfBeers()
        waitForExpectations(timeout: TimeInterval.value)
    }
    
    func testGetListOfBeersFailure() {
        MainData.staticToggleForCoreData = true
        viewModel.repository.deleteData()
        
        mock.setMock(data: nil, error: .unknown)
        let exp = expectation(description: "first page list failure")
        viewModel.errorObservable.didChange = { error in
            XCTAssertNotNil(error)
            exp.fulfill()
        }
        viewModel.getListOfBeers()
        waitForExpectations(timeout: TimeInterval.value)
    }
    
    func testGetListOfBeersUserDefaults() {
        MainData.staticToggleForCoreData = true
        viewModel.repository.deleteData()
        viewModel.repository.saveData(data: RepositoryModel(data: [setup.getModel()],
                                                            pages: 1))
        let exp = expectation(description: "first page list success")
        viewModel.requestObervable.didChange = { value in
            XCTAssertEqual(value?.count, 1)
            XCTAssertEqual(value?.first?.name, self.setup.getModel().name)
            XCTAssertEqual(value?.first?.id, self.setup.getModel().id)
            exp.fulfill()
        }
        
        viewModel.getListOfBeers()
        waitForExpectations(timeout: TimeInterval.value)
    }
    
    func testGetNextBeersSuccess() {
        MainData.staticToggleForCoreData = true
        CoreData.shared.deleteAllData()
        viewModel.requestObervable.value = [setup.getModel()]
        viewModel.lastPage = false
        
        mock.setMock(data: setup.getMockSucces(), error: nil)
        let exp = expectation(description: "next page list success")
        viewModel.requestObervable.didChange = { value in
            XCTAssertEqual(value?.count, 2)
            XCTAssertEqual(value?.first?.name, self.setup.getModel().name)
            XCTAssertEqual(value?.first?.id, self.setup.getModel().id)
            XCTAssertEqual(value?.last?.name, self.setup.getModel().name)
            XCTAssertEqual(value?.last?.id, self.setup.getModel().id)
            exp.fulfill()
        }
        
        viewModel.getNextBeers()
        waitForExpectations(timeout: TimeInterval.value)
    }
    
    func testGetNextBeersFailure() {
        MainData.staticToggleForCoreData = true
        CoreData.shared.deleteAllData()
        viewModel.requestObervable.value = [setup.getModel()]
        viewModel.lastPage = false
        
        mock.setMock(data: nil, error: .unknown)
        let exp = expectation(description: "next page list failure")
        viewModel.errorObservable.didChange = { error in
            XCTAssertNotNil(error)
            exp.fulfill()
        }
        
        viewModel.getNextBeers()
        waitForExpectations(timeout: TimeInterval.value)
    }
    
    func testGetNextBeersCoreData() {
        MainData.staticToggleForCoreData = true
        CoreData.shared.deleteAllData()
        CoreData.shared.saveData(model: RepositoryModel(data: [setup.getModel()],
                                                        pages: viewModel.page + 1))
        
        let exp = expectation(description: "next page list success")
        viewModel.requestObervable.didChange = { value in
            XCTAssertEqual(value?.count, 1)
            XCTAssertEqual(value?.first?.name, self.setup.getModel().name)
            XCTAssertEqual(value?.first?.id, self.setup.getModel().id)
            XCTAssertEqual(value?.last?.name, self.setup.getModel().name)
            XCTAssertEqual(value?.last?.id, self.setup.getModel().id)
            exp.fulfill()
        }
        
        viewModel.getNextBeers()
        waitForExpectations(timeout: TimeInterval.value)
    }
    
    func testGetNextBeersSuccessLastPage() {
        viewModel.lastPage = false
        
        viewModel.nextBeerListIsLast([])
        viewModel.getNextBeers()
        
        XCTAssertEqual(self.viewModel.lastPage, true)
    }
    
    func testSearchBeersSuccess() {
        mock.setMock(data: setup.getMockSucces(), error: nil)
        let exp = expectation(description: "search list success")
        
        viewModel.searchObservable.didChange = { value in
            XCTAssertEqual(value?.count, 1)
            XCTAssertEqual(value?.first?.name, self.setup.getModel().name)
            XCTAssertEqual(value?.first?.id, self.setup.getModel().id)
            exp.fulfill()
        }
        
        viewModel.searchBeers(name: "")
        
        waitForExpectations(timeout: TimeInterval.value)
    }
    
    func testSearchBeersFailure() {
        mock.setMock(data: nil, error: .unknown)
        let exp = expectation(description: "search list failure")
        
        viewModel.errorObservable.didChange = { error in
            XCTAssertNotNil(error)
            exp.fulfill()
        }
        
        viewModel.searchBeers(name: "")
        
        waitForExpectations(timeout: TimeInterval.value)
    }
    
    func testGoToBeerDetails() {
        viewModel.delegate = self
        viewModel.goToBeerDetails(model: setup.getModel())
        XCTAssertTrue(beerDetails)
    }
    
}

extension BeerListViewModelTests: BeerListViewModelDelegate {
    func beerDetails(model: BeerModel) {
        beerDetails = true
    }
}
