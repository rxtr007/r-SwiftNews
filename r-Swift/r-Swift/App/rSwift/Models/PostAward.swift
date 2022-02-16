//
//  PostAward.swift
//  r-Swift

import Foundation
import UIKit.UIImage

// MARK: - PostAward

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

// MARK: - PostAward URLGettable

extension PostAward: URLGettable {
    var iconURL: URL? {
        return URL(string: "\(iconURLString ?? "")")!
    }
}
