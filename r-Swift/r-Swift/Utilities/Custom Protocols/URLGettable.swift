//
//  URLGettable.swift
//  r-Swift
//
//  Created by Sachin Ambegave on 10/02/22.
//

import Foundation

/// Get icon/thumbnail URL from a Object used to display information about reddit post
protocol URLGettable {
    var iconURL: URL? { get }
}
