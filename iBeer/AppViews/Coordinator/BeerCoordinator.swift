//
//  BeerCoordinator.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import UIKit

class BeerCoordinator {
    
    var navigation: UINavigationController?
    
    func start() -> UINavigationController {
        let navigation = UINavigationController(rootViewController: BeerListViewController())
        self.navigation = navigation
        return navigation
    }
}
