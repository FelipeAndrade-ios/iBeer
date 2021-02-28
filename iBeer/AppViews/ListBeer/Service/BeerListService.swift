//
//  BeerListService.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import SDKNetwork

class BeerListService: Service<BeerListProvider> {
    func getListOfBeers(model: RequestModel, completion: @escaping (Result<[BeerModel], RequestError>) -> Void) {
        request(BeerListProvider.list(model: model), model: [BeerModel].self) { (result, _) in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
