//
//  MockModel.swift
//  iBeerTests
//
//  Created by Felipe Andrade on 28/02/21.
//

import XCTest
import SDKNetwork
@testable import iBeer

class MockSetup {
    func getMockSucces() -> Data? {
        let model = [getModel()]
        return try? JSONEncoder().encode(model)
    }
    
    func getMockEmpty() -> Data? {
        let model = [BeerModel]()
        return try? JSONEncoder().encode(model)
    }
    
    func getModel() -> BeerModel {
        return BeerModel(id: 0,
                          name: "name",
                          description: nil,
                          image_url: nil,
                          abv: nil,
                          ibu: nil,
                          tagline: nil)
    }
    
    func getMockError() -> RequestError {
        return .unknown
    }
}

class TestRequester: Request {
    var data: Data?
    var error: RequestError?
    
    func setMock(data: Data?, error: RequestError?) {
        self.data = data
        self.error = error
    }
    
    func makeRequest(_ service: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard data != nil || error != nil else {
            XCTFail("The mock must be set")
            return
        }
        completion(data, nil, error)
    }
}

extension TimeInterval {
    static var value: TimeInterval { return 2 }
}
