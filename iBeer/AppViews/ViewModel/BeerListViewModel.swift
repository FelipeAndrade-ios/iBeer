//
//  BeerListViewModel.swift
//  iBeer
//
//  Created by Felipe Andrade on 23/02/21.
//

import Foundation

class BeerListViewModel {
    var service = BeerListService()
    var requestObervable = Observable<[BeerModel]>()

    func getListOfBeers() {
        service.getListOfBeers { result in
            switch result {
            case .success(let data):
                self.requestObervable.value = data
            case .failure:
                print("Ignoring error for now")
            }
        }
    }
}
