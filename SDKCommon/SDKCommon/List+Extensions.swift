//
//  UITableView+Extensions.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import UIKit

public extension UITableView {
    func register<T: UITableViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: T.className, bundle: nil),
                      forCellReuseIdentifier: T.className)
    }
}

public extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: T.className, bundle: Bundle(for: T.self)),
                      forCellWithReuseIdentifier: T.className)
    }
}
