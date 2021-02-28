//
//  Observable.swift
//  iBeer
//
//  Created by Felipe Andrade on 22/02/21.
//

import Foundation

public class Observable<T> {
    public var didChange: ((T?) -> Void)?
    public var value: T? {
        didSet {
            self.didChange?(self.value)
        }
    }

    public init(_ value: T? = nil) {
        self.value = value
    }

    deinit {
        didChange = nil
    }
}
