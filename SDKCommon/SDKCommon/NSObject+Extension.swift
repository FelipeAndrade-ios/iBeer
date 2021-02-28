//
//  NSObject+Extension.swift
//  SDKCommon
//
//  Created by Felipe Andrade on 27/02/21.
//

import Foundation

/** This variable will return the name of the class, in this project, this is used for the register of cells
*/
public extension NSObject {
    static var className: String {
        String(describing: self.self)
    }
}
