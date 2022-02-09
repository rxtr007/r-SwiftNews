//
//  Observable.swift
//  r-Swift
//
//  Created by Sachin Ambegave on 10/02/22.
//

import Foundation

// MARK: - Generic class which observes changes to data

/// Generic class which observes changes to data
class Observable<T> {
    /// Generic value to be observed
    var value: T? {
        didSet {
            observer?(value)
        }
    }

    init(_ value: T?) {
        self.value = value
    }

    typealias ObserverClosure = (T?) -> Void

    private var observer: ObserverClosure?

    /// methods that binds the data to be observed with the observer
    func bind(_ observer: @escaping ObserverClosure) {
        self.observer = observer
    }
}
