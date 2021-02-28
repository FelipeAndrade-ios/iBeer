//
//  BeerListProvider.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import SDKNetwork
import SDKCommon

enum BeerListProvider {
    case list(model: RequestModel)
}

extension BeerListProvider: ServiceRequest {
    var url: String {
        switch self {
        case .list:
            return "\(MainData.BaseURL)beers"
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
        case .list(let model):
            return DataTask.urlEncoded(model.dictionary)
        }
    }
}
