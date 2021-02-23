//
//  BeerListService.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import SDKNetwork

class BeerListService: Service<BeerListProvider> {
    func getListOfBeers(completion: @escaping (Result<[BeerModel], Error>) -> Void) {
        request(BeerListProvider.list, model: [BeerModel].self) { (result, _) in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
