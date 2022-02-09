//
//  Cancellable.swift
//  r-Swift
//
//  Created by Sachin Ambegave on 10/02/22.
//

import Foundation

/// Cancel running/ongoing URLSession Tasks
protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {
    // We don't need to add method of `Cancellable` protocol as `URLSessionTask` already contains the method with exact same name
}
