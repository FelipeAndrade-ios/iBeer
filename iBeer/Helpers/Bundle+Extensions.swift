//
//  NSObject+Extensions.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import Foundation

// Defining this class we can make sure that the  `currentBundle` will not be affected by the views
class BundleiBeerClass: NSObject {}

extension Bundle {
    static var currentBundle: Bundle {
        Bundle(for: BundleiBeerClass.self)
    }
}
