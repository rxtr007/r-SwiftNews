//
//  URLGettable.swift
//  r-Swift

import Foundation

/// Get icon/thumbnail URL from a Object used to display information about reddit post
protocol URLGettable {
    var iconURL: URL? { get }
}
