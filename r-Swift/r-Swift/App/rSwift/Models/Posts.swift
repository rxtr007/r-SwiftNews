//
//  Posts.swift
//  r-Swift

import Foundation
import UIKit.UIImage

// MARK: - Posts

/// Posts Object for post collection in r/Swift
struct Posts {
    let post: Post
}

// MARK: - Post Decodable

extension Posts: Decodable {
    enum CodingKeys: String, CodingKey {
        case post = "data"
    }
}
