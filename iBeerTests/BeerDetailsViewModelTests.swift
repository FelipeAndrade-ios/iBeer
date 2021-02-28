//
//  BeerDetaisViewModelTests.swift
//  iBeerTests
//
//  Created by Felipe Andrade on 28/02/21.
//

import XCTest
@testable import iBeer

class BeerDetailsViewModelTests: XCTestCase {

    var viewModel: BeerDetailsViewModel!
    let setup = MockSetup()
    
    override func tearDown() {
        viewModel = nil
    }
    
    func testGetImageURL() {
        let urlString = "https://google.com"
        let model = BeerModel(id: 0,
                              name: "",
                              description: nil,
                              image_url: urlString,
                              abv: nil,
                              ibu: nil,
                              tagline: nil)
        viewModel = BeerDetailsViewModel(beerModel: model)
        let url = viewModel.getImageURL()
        XCTAssertEqual(url?.absoluteString, urlString)
    }
    
    func testGetImageURLEmpty() {
        let model = BeerModel(id: 0,
                              name: "",
                              description: nil,
                              image_url: nil,
                              abv: nil,
                              ibu: nil,
                              tagline: nil)
        viewModel = BeerDetailsViewModel(beerModel: model)
        let url = viewModel.getImageURL()
        XCTAssertNil(url?.absoluteString)
    }
    
    func testGetAbvNotNil() {
        let abv = 1.0
        let model = BeerModel(id: 0,
                              name: "",
                              description: nil,
                              image_url: nil,
                              abv: abv,
                              ibu: nil,
                              tagline: nil)
        viewModel = BeerDetailsViewModel(beerModel: model)
        let label = viewModel.getAbv()
        XCTAssertEqual(label, String(format: "%.1f %@ABV", arguments: [abv, "%"]))
    }
    
    func testGetAbvNil() {
        let model = BeerModel(id: 0,
                              name: "",
                              description: nil,
                              image_url: nil,
                              abv: nil,
                              ibu: nil,
                              tagline: nil)
        viewModel = BeerDetailsViewModel(beerModel: model)
        let label = viewModel.getAbv()
        XCTAssertEqual(label, "ABV not informed")
    }
    
    func testGetIBUNotNil() {
        let ibu = 1.0
        let model = BeerModel(id: 0,
                              name: "",
                              description: nil,
                              image_url: nil,
                              abv: nil,
                              ibu: ibu,
                              tagline: nil)
        viewModel = BeerDetailsViewModel(beerModel: model)
        let label = viewModel.getIBU()
        XCTAssertEqual(label, "\(Int(ibu)) IBU")
    }
    
    func testGetIBUNil() {
        let model = BeerModel(id: 0,
                              name: "",
                              description: nil,
                              image_url: nil,
                              abv: nil,
                              ibu: nil,
                              tagline: nil)
        viewModel = BeerDetailsViewModel(beerModel: model)
        let label = viewModel.getIBU()
        XCTAssertEqual(label, "IBU not informed")
    }
}
