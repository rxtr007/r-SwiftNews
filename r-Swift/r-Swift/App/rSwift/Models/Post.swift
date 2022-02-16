//
//  Post.swift
//  r-Swift

import Foundation
import UIKit.UIImage

// MARK: - Post

/// Underlying Post Model in Post Object
struct Post {
    let id: String
    let description: String
    let title: String
    let thumbnail: String?
    let thumbnailWidth: Int?
    let thumbnailHeight: Int?
    let allAwards: [Award]?
}

// MARK: - Post Decodable

extension Post: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, thumbnail
        case description = "selftext"
        case allAwards = "all_awardings"
        case thumbnailWidth = "thumbnail_width"
        case thumbnailHeight = "thumbnail_height"
    }
}
