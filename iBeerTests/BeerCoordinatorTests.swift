//
//  BeerCoordinatorTests.swift
//  iBeerTests
//
//  Created by Felipe Andrade on 28/02/21.
//

import XCTest
@testable import iBeer

class BeerCoordinatorTests: XCTestCase {

    var coordinator: BeerCoordinator?
    
    override func setUp() {
        super.setUp()
        
        coordinator = BeerCoordinator()
    }
    
    override func tearDown() {
        coordinator = nil
    }
    
    func testStart() {
        _ = coordinator?.start()
        XCTAssertNotNil(coordinator?.navigation)
        XCTAssertTrue(coordinator?.navigation?.viewControllers.first is BeerListCollectionViewController)
    }
    
    func testBeerDetails() {
        _ = coordinator?.start()
        let model = BeerModel(id: 0,
                              name: "name",
                              description: nil,
                              image_url: nil,
                              abv: nil,
                              ibu: nil,
                              tagline: nil)
        coordinator?.beerDetails(model: model)
        
        XCTAssertNotNil(coordinator?.beerDetailsView)
        XCTAssertEqual(coordinator?.beerDetailsViewModel?.model.name, model.name)
        XCTAssertEqual(coordinator?.beerDetailsViewModel?.model.id, model.id)
        XCTAssertEqual(coordinator?.beerDetailsViewModel?.model.description, model.description)
    }
}
