//
//  PostCellModel.swift
//  r-Swift

import Foundation
import UIKit.UIImage

// MARK: - PostCellModel

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

// MARK: - PostCellModel URLGettable

extension PostCellModel: URLGettable {
    var iconURL: URL? {
        return URL(string: "\(thumbnail ?? "")")!
    }
}
