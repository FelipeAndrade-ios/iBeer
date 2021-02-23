//
//  UITableView+Extensions.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: String(T.className), bundle: Bundle.currentBundle),
                      forCellReuseIdentifier: String(T.className))
    }
}
