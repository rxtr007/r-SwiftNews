//
//  Model.swift
//  r-Swift
//
//  Created by Sachin Ambegave on 10/02/22.
//

import Foundation
import UIKit.UIImage

// MARK: - News Object to use inside table view cell

/// News Object to use inside table view cell
class NewsCellModel {
    let id: String
    let title: String
    let description: String
    let thumbnail: String?
    let thumbnailWidth: Int?
    let thumbnailHeight: Int?
    let allAwards: [NewsAward]?
    var thumbnailImage: UIImage!

    init(
        id: String,
        title: String,
        description: String,
        thumbnail: String?,
        thumbnailWidth: Int?,
        thumbnailHeight: Int?,
        allAwards: [NewsAward]?,
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

// MARK: NewsCellModel URLGettable icon URL

extension NewsCellModel: URLGettable {
    var iconURL: URL? {
        return URL(string: "\(thumbnail ?? "")")!
    }
}

class NewsAward {
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

// MARK: NewsAward URLGettable icon URL

extension NewsAward: URLGettable {
    var iconURL: URL? {
        return URL(string: "\(iconURLString ?? "")")!
    }
}

// MARK: - Underlying News Model in News Object

/// Underlying News Model in News Object
struct News {
    let id: String
    let description: String
    let title: String
    let thumbnail: String?
    let thumbnailWidth: Int?
    let thumbnailHeight: Int?
    let allAwards: [Award]?
}

// MARK: News Model Coding Keys

extension News: Decodable {
    enum CodingKeys: String, CodingKey {
        case id, title, thumbnail
        case description = "selftext"
        case allAwards = "all_awardings"
        case thumbnailWidth = "thumbnail_width"
        case thumbnailHeight = "thumbnail_height"
    }
}

// MARK: - Award Model

/// Award Object Model for each news/post
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

// MARK: - News Object

/// News Object for each news/post in r/Swift
struct SwiftNews {
    let news: News
}

// MARK: News Object Coding Keys

extension SwiftNews: Decodable {
    enum CodingKeys: String, CodingKey {
        case news = "data"
    }
}

// MARK: - Top Level Children in r/Swift Object

/// Top Level Children in r/Swift Object
struct Children: Decodable {
    let children: [SwiftNews]
}

// MARK: - Top Level Object in r/Swift json

/// Top Level Object in r/Swift json
struct Model: Decodable {
    let data: Children
}
