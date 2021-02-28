//
//  AppCoordinator.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import UIKit

class AppCoordinator {
    
    let window: UIWindow
    let mainCoordinator = BeerCoordinator()
    
    init(_ window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = mainCoordinator.start()
        window.makeKeyAndVisible()
    }
}
// TODO: Uinit test 40%
// TODO: UI Test on Main app
// TODO: CI on git
// TODO: Readme 5%
