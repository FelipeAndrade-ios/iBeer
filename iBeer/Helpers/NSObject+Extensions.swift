//
//  NSObject+Extensions.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import Foundation

/** This variable will return the name of the class, in this project, this is used for the register of cells
*/
extension NSObject {
    static var className: String {
        String(describing: self.self)
    }
}

/** Defining this class we can make sure that the  `currentBundle` will not be affected by the views
*/
class BundleDefiner: NSObject {}

extension Bundle {
    static var currentBundle: Bundle {
        Bundle(for: BundleDefiner.self)
    }
}
