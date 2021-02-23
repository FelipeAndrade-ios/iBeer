//
//  Observable.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import Foundation

public class Observable<T> {
    
    var didChange: ((T?) -> Void)?
    var value: T? {
        didSet {
            DispatchQueue.main.async {
                self.didChange?(self.value)
            }
        }
    }

    init(_ value: T? = nil) {
        self.value = value
    }

    deinit {
        didChange = nil
    }
}
