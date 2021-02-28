//
//  BeerListViewModel.swift
//  iBeer
//
//  Created by Felipe Andrade on 23/02/21.
//

import Foundation
import SDKCommon
import SDKNetwork

protocol BeerListViewModelDelegate: AnyObject {
    func beerDetails(model: BeerModel)
}

class BeerListViewModel {
    var service = BeerListService()
    
    var requestObervable = Observable<[BeerModel]>()
    var searchObservable = Observable<[BeerModel]>()
    var errorObservable  = Observable<RequestError>()
    
    var beerSortedByMalts: [String: [BeerModel]] = [String: [BeerModel]]()
    var page: Int = 1
    var lastPage = false
    
    let repository = LocalRepository<RepositoryModel>()
    weak var delegate: BeerListViewModelDelegate?
    
    func getListOfBeers() {
        if let repoModel = repository.loadData(), MainData.staticToggleForUserDefaults {
            requestObervable.value = repoModel.data
        } else {
            service.getListOfBeers(model: RequestModel(page: page)) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let self = self else { return }
                    self.requestObervable.value = data
                    // Saving here only the first
                    self.repository.saveData(data: RepositoryModel(data: data, pages: self.page))
                    self.page += 1
                case .failure(let error):
                    self?.errorObservable.value = error
                }
            }
        }
    }
    
    func goToBeerDetails(model: BeerModel) {
        delegate?.beerDetails(model: model)
    }
    
    func getNextBeers() {
        guard !lastPage else { return }
        
        if let dataModel = CoreData.shared.getData(),
           dataModel.pages > page, MainData.staticToggleForCoreData {
            requestObervable.value = dataModel.data
            page = dataModel.pages
        } else {
            service.getListOfBeers(model: RequestModel(page: page)) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.nextBeerListIsLast(data)
                case .failure(let error):
                    self?.errorObservable.value = error
                }
            }
        }
    }
    
    func nextBeerListIsLast(_ data: [BeerModel]) {
        if data.count > 0 {
            self.requestObervable.value?.append(contentsOf: data)
        } else {
            self.lastPage = true
        }
        self.page += 1
        self.saveToCoreData(model: data)
    }
    
    func searchBeers(name: String) {
        let nameForRequest = name.replacingOccurrences(of: " ", with: "_")
        service.getListOfBeers(model: RequestModel(page: page, beer_name: nameForRequest)) { [weak self] result in
            switch result {
            case .success(let data):
                self?.searchObservable.value = data
            case .failure(let error):
                self?.errorObservable.value = error
            }
        }
    }
    
    func saveToCoreData(model: [BeerModel]) {
        DispatchQueue.main.async {
            let repositoryModel = RepositoryModel(data: model,
                                                  pages: self.page)
            CoreData.shared.saveData(model: repositoryModel)
        }
    }
}
