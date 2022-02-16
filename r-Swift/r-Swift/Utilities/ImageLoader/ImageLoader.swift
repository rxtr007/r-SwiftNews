//
//  ImageLoader.swift
//  r-Swift

import Foundation
import UIKit.UIImage

// MARK: - ImageLoader

/// Final class with function to download image from class which confirms to *URLGettable* protocol. The same function returns a task of type *Cancellable* which we can use to cancel URLSession tasks from reusable cells if needed, and provides a completion handler which contains downloaded image, the post object model and error.
final class ImageLoader {
    @available(iOS 13.0, *)
    static let placeholderSFImage = UIImage(systemName: Constants.Strings.Rectangle)!
    static let placeholderImage = UIImage(named: Constants.Strings.Rectangle)

    // MARK: loadImage

    func loadImage<T: URLGettable>(for model: T, completion: @escaping (T, UIImage?, Error?) -> Void) -> Cancellable {
        let task = URLSession.shared.dataTask(with: model.iconURL!) { data, _, error in
            var image: UIImage?
            var downloadError: Error?

            if let error = error {
                downloadError = error
            }

            defer {
                // Execute Handler on Main Thread
                DispatchQueue.main.async {
                    // pass back the image and update the post object model
                    completion(model, image, downloadError)
                }
            }

            if let data = data, let img = UIImage(data: data) {
                image = img
            }
        }
        task.resume()

        return task
    }
}
