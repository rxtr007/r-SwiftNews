//
//  NetworkLayer.swift
//  r-Swift

import Foundation

// MARK: - NetworkLayer

class NetworkLayer {
    static let shared = NetworkLayer()

    // MARK: private init

    private init() {}

    // MARK: makeSession

    func makeSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Constants.CGFloatValue.k60
        config.timeoutIntervalForResource = Constants.CGFloatValue.k60
        return URLSession(configuration: config)
    }

    // MARK: task

    @discardableResult
    func task(for url: URL, completion: @escaping (Data?, Error?) -> Void) -> Cancellable {
        let session = makeSession()
        let task = session.dataTask(with: url) { data, response, error in
            var responseData: Data?
            var downloadError: Error?

            if let error = error {
                downloadError = error
            }

            defer {
                // pass back the image and update the post object model
                completion(responseData, downloadError)
            }

            if let data = data, let _ = response {
                responseData = data
            }
        }
        task.resume()

        return task
    }

    // MARK: makeRequest

    func makeRequest(for url: URL, completion: @escaping (Data?, Error?) -> Void) {
        task(for: url, completion: completion)
    }
}
