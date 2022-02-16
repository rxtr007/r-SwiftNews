//
//  Constants.swift
//  r-Swift

import UIKit

// MARK: - Constants

enum Constants {
    // MARK: CGFloatValue

    enum CGFloatValue {
        static let kPoint3: CGFloat = 0.3
        static let k0: CGFloat = 0
        static let k1: CGFloat = 1
        static let k2: CGFloat = 2
        static let k4: CGFloat = 4
        static let k8: CGFloat = 8
        static let k10: CGFloat = 10
        static let k16: CGFloat = 16
        static let k32: CGFloat = 32
        static let k35: CGFloat = 35
        static let k40: CGFloat = 40
        static let k44: CGFloat = 44
        static let k50: CGFloat = 50
        static let k60: CGFloat = 60
        static let k80: CGFloat = 80
        static let k200: CGFloat = 200
    }

    // MARK: Strings

    enum Strings {
        static let `Self` = "self"
        static let HomeTitle = "Swift News"
        static let Rectangle = "rectangle"
    }

    // MARK: Error

    enum Error {
        static let Title = "An error occurred"
        static let Message = "Oops, something went wrong!"
    }

    // MARK: Button

    enum Button {
        static let Retry = "Retry"
        static let Close = "Close"
    }

    // MARK: Storyboard

    enum Storyboard {
        static let Main = "Main"
    }

    // MARK: API

    enum API {
        static let BaseURL = "https://www.reddit.com/"
        static let Endpoint = "r/swift/.json"
    }

    // MARK: ScreenSize

    enum ScreenSize {
        static let Height = UIScreen.main.bounds.height
        static let Width = UIScreen.main.bounds.width
    }
}
