//
//  iBeerUITests.swift
//  iBeerUITests
//
//  Created by Felipe Andrade on 22/02/21.
//

import XCTest

class IBeerUITests: XCTestCase {

    let app = XCUIApplication()
    
    func testAppiBeer() {
        app.launch()
        
        let collection = app.collectionViews.matching(identifier: "beerCollectionView")
        let cell = collection.cells.element(matching: .cell, identifier: "BeerCell0")
        
        waitForCellsToAppear(cell)
        app.swipeUp()
        
        getCellAndClick(collection: collection)
        
        goBack()
        
        searchAndClickOnFirst(cell)
        
        cell.tap()
        
        verifyData()
    }
    
    func waitForCellsToAppear(_ cell: XCUIElement) {
        expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: cell, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(app.staticTexts["iBeer"].exists)
        
        XCTAssertTrue(cell.exists)
    }
    
    func getCellAndClick(collection: XCUIElementQuery) {
        let cellToClick = collection.cells.element(matching: .cell, identifier: "BeerCell8")
        cellToClick.tap()
        
        print(app.debugDescription)
    }
    
    func goBack() {
        app.navigationBars.buttons.element(boundBy: 0).tap()
    }
    
    func searchAndClickOnFirst(_ cell: XCUIElement) {
        app.swipeDown()
        app.swipeDown()
        app.navigationBars.searchFields["Search"].tap()
        app.searchFields["Search"].typeText("AB:1")
        
        expectation(for: NSPredicate(format: "exists == true"),
                    evaluatedWith: cell.staticTexts["AB:12"], handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func verifyData() {
        XCTAssertTrue(app.staticTexts["AB:12"].exists)
        XCTAssertTrue(app.staticTexts["11.2 %ABV"].exists)
        XCTAssertTrue(app.staticTexts["35 IBU"].exists)
    }
}
