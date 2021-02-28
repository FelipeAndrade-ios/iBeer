//
//  BeerCoordinator.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import UIKit

class BeerCoordinator {
    
    var navigation: UINavigationController?
    
    var beerListView: BeerListCollectionViewController?
    var beerListViewModel: BeerListViewModel?
    
    var beerDetailsView: BeerDetailsViewController?
    var beerDetailsViewModel: BeerDetailsViewModel?
    
    func start() -> UINavigationController {
        let navigation = UINavigationController(rootViewController: getBeerList())
        self.navigation = navigation
        return navigation
    }
    
    func getBeerList() -> BeerListCollectionViewController {
        let viewModel = BeerListViewModel()
        let beerListView = BeerListCollectionViewController(viewModel)
        viewModel.delegate = self
        self.beerListViewModel = viewModel
        self.beerListView = beerListView
        return beerListView
    }
}

extension BeerCoordinator: BeerListViewModelDelegate {
    func beerDetails(model: BeerModel) {
        let viewModel = BeerDetailsViewModel(beerModel: model)
        let beerDetailsView = BeerDetailsViewController(viewModel: viewModel)
        self.beerDetailsViewModel = viewModel
        self.beerDetailsView = beerDetailsView
        self.navigation?.pushViewController(beerDetailsView, animated: true)
    }
}
