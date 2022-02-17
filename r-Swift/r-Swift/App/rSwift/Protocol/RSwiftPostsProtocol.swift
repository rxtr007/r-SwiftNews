//
//  RSwiftPostsProtocol.swift
//  r-Swift

import Foundation

protocol RSwiftPostsProtocol {
    /// number of posts in reddit channel r/Swift
    var posts: Observable<[PostCellModel]> { get set }

    // MARK: loadRedditPosts

    /// Load Reddit Posts by making the Network Request
    func requestRedditPosts(onError: @escaping (Bool) -> Void)

    // MARK: handleResponse

    func handleResponse(from data: Data, isError: @escaping (Bool) -> Void)

    // MARK: save

    func save(_ redditPosts: [Posts])
}
