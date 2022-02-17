//
//  RSwiftViewModel.swift
//  r-Swift

import Foundation
import UIKit.UIImage

// MARK: - RSwiftViewModel

struct RSwiftViewModel: RSwiftPostsProtocol {
    /// number of posts in reddit channel r/Swift
    var posts: Observable<[PostCellModel]> = Observable([])
    
    var network: NetworkLayer = NetworkLayer.shared
    
    // MARK: requestRedditPosts

    /// Load Reddit Posts by making the Network Request
    func requestRedditPosts(onError: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(Constants.API.BaseURL)\(Constants.API.Endpoint)") else { onError(true); return }
        
        network.makeRequest(for: url) { data, error in
            
            guard error == nil else { onError(true); return }
            
            guard let data = data else { onError(true); return }
            
            handleResponse(from: data, isError: onError)
        }
    }

    // MARK: handleResponse

    func handleResponse(from data: Data, isError: @escaping (Bool) -> Void) {
        do {
            let redditPosts = try JSONDecoder().decode(Model.self, from: data)
            
            save(redditPosts.data.children)
            
            isError(false)
        } catch {
            print(error.localizedDescription)
            isError(true)
        }
    }
    
    // MARK: save

    func save(_ redditPosts: [Posts]) {
        var image: UIImage!
        
        if #available(iOS 13.0, *) {
            image = ImageLoader.placeholderSFImage
        } else {
            image = ImageLoader.placeholderImage
        }
        let rPosts = redditPosts.compactMap {
            PostCellModel(
                id: $0.post.id,
                title: $0.post.title,
                description: $0.post.description,
                thumbnail: $0.post.thumbnail,
                thumbnailWidth: $0.post.thumbnailWidth,
                thumbnailHeight: $0.post.thumbnailHeight,
                allAwards: $0.post.allAwards?.compactMap {
                    PostAward(iconURLString: $0.iconURL, iconHeight: $0.iconHeight, iconWidth: $0.iconWidth, icon: image)
                }, thumbnailImage: image)
        }
            
        posts.value = rPosts
    }
}
