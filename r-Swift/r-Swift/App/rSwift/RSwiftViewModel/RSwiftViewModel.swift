//
//  RSwiftViewModel.swift
//  r-Swift

import Foundation
import UIKit.UIImage

// MARK: - RSwiftViewModel

struct RSwiftViewModel {
    /// number of posts in reddit channel r/Swift
    var posts: Observable<[PostCellModel]> = Observable([])
    
    // MARK: loadRedditPosts

    /// Load Reddit Posts by making the Network Request
    func loadRedditPosts(onError: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(Constants.API.BaseURL)\(Constants.API.Endpoint)") else { onError(true); return }
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = Constants.CGFloatValue.k60
        config.timeoutIntervalForResource = Constants.CGFloatValue.k60
        let session = URLSession(configuration: config)
        
        session.dataTask(with: url) { data, _, error in
            
            guard error == nil else { onError(true); return }
            
            guard let data = data else { onError(true); return }
            
            do {
                var image: UIImage!
                
                if #available(iOS 13.0, *) {
                    image = ImageLoader.placeholderSFImage
                } else {
                    image = ImageLoader.placeholderImage
                }
                
                let redditPosts = try JSONDecoder().decode(Model.self, from: data)
                
                let rPosts = redditPosts.data.children.compactMap {
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
                onError(false)
            } catch {
                print(error.localizedDescription)
                onError(true)
            }
        }.resume()
    }
}
