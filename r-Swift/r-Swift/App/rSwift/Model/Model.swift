//
//  Model.swift
//  r-Swift
//
//  Created by Sachin Ambegave on 10/02/22.
//

import Foundation
import UIKit.UIImage

// MARK: - Post Object to use inside table view cell

/// Post Object to use inside table view cell
class PostCellModel {
    let id: String
    let title: String
    let description: String
    let thumbnail: String?
    let thumbnailWidth: Int?
    let thumbnailHeight: Int?
    let allAwards: [PostAward]?
    var thumbnailImage: UIImage!

    init(
        id: String,
        title: String,
        description: String,
        thumbnail: String?,
        thumbnailWidth: Int?,
        thumbnailHeight: Int?,
        allAwards: [PostAward]?,
        thumbnailImage: UIImage
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.thumbnail = thumbnail
        self.thumbnailWidth = thumbnailWidth
        self.thumbnailHeight = thumbnailHeight
        self.allAwards = allAwards
        self.thumbnailImage = thumbnailImage
    }
}

// MARK: PostCellModel URLGettable icon URL

extension PostCellModel: URLGettable {
    var iconURL: URL? {
        return URL(string: "\(thumbnail ?? "")")!
    }
}

class PostAward {
    let iconURLString: String?
    let iconHeight: Int?
    let iconWidth: Int?
    var icon: UIImage!
    init(
        iconURLString: String?,
        iconHeight: Int?,
        iconWidth: Int?,
        icon: UIImage
    ) {
        self.iconURLString = iconURLString
        self.iconHeight = iconHeight
        self.iconWidth = iconWidth
        self.icon = icon
    }
}

// MARK: PostAward URLGettable icon URL

extension PostAward: URLGettable {
    var iconURL: URL? {
        return URL(string: "\(iconURLString ?? "")")!
    }
}

// MARK: - Underlying Post Model in Post Object

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

// MARK: Post Model Coding Keys

extension Post: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, thumbnail
        case description = "selftext"
        case allAwards = "all_awardings"
        case thumbnailWidth = "thumbnail_width"
        case thumbnailHeight = "thumbnail_height"
    }
}

// MARK: - Award Model

/// Award Object Model for each post
struct Award {
    let iconURL: String
    let iconHeight: Int
    let iconWidth: Int
}

// MARK: Award Model Coding Keys

extension Award: Decodable {
    enum CodingKeys: String, CodingKey {
        case iconHeight = "icon_height"
        case iconWidth = "icon_width"
        case iconURL = "icon_url"
    }
}

// MARK: - Posts Object

/// Posts Object for post collection in r/Swift
struct Posts {
    let post: Post
}

// MARK: Post Object Coding Keys

extension Posts: Decodable {
    enum CodingKeys: String, CodingKey {
        case post = "data"
    }
}

// MARK: - Top Level Children in r/Swift Object

/// Top Level Children in r/Swift Object
struct Children: Decodable {
    let children: [Posts]
}

// MARK: - Top Level Object in r/Swift json

/// Top Level Object in r/Swift json
struct Model: Decodable {
    let data: Children
}
