//
//  Award.swift
//  r-Swift

import Foundation
import UIKit.UIImage

// MARK: - Award

/// Award Object Model for each post
struct Award {
    let iconURL: String
    let iconHeight: Int
    let iconWidth: Int
}

// MARK: - Award Decodable

extension Award: Decodable {
    enum CodingKeys: String, CodingKey {
        case iconHeight = "icon_height"
        case iconWidth = "icon_width"
        case iconURL = "icon_url"
    }
}
