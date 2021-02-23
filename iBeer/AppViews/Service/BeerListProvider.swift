//
//  BeerListProvider.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import SDKNetwork

enum BeerListProvider {
    case list
    case beerDetails(Int)
}

extension BeerListProvider: ServiceRequest {
    var url: String {
        switch self {
        case .list:
            return "\(MainData.BaseURL)beers"
        case .beerDetails(let id):
            return "\(MainData.BaseURL)beers/\(id)"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var header: [String: String]? {
        nil
    }
    
    var data: DataTask.RequestContent {
        switch self {
        case .list:
            return .urlEncoded("")
        case .beerDetails:
            return .plain
        }
    }
}
