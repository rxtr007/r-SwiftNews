//
//  Identifiable.swift
//  r-Swift

import Foundation

/// Provide identifier to UI elements
protocol Identifiable {
    static var identifier: String { get }
}
