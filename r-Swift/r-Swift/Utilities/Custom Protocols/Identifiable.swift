//
//  Identifiable.swift
//  r-Swift
//
//  Created by Sachin Ambegave on 10/02/22.
//

import Foundation

/// Provide identifier to UI elements
protocol Identifiable {
    static var identifier: String { get }
}
