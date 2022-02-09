//
//  ViewModel.swift
//  r-Swift
//
//  Created by Sachin Ambegave on 10/02/22.
//

import Foundation
import UIKit.UIImage

struct RSwiftViewModel {
    var posts: Observable<[PostCellModel]> = Observable([])
    
    func loadRedditPosts(onError: @escaping (Bool) -> Void) {
        let baseURL = "https://www.reddit.com/"
        let endpoint = "r/swift/.json"
        let urlSession = URLSession.shared
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else { onError(true); return }
        
        urlSession.dataTask(with: url) { data, _, error in
            
            guard error == nil else { onError(true); return }
            
            guard let data = data else { onError(true); return }
            
            do {
                var image: UIImage! = UIImage(named: "")!
                
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
                onError(true)
                print(error.localizedDescription)
            }
        }.resume()
    }
}

enum RedditPostsError: Error {
    case apiError
    case invalidEndPoint
    case invalidResponse
    case noData
    case serializationError
}
