//
//  PostDetailTableViewCell.swift
//  r-Swift
//
//  Created by Sachin Ambegave on 10/02/22.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {
    private static var thumbnailImageViewDefaultBottom: CGFloat = 8
    private static var thumbnailImageViewDefaultHeight: CGFloat = 80

    @IBOutlet private var postDescriptionLabel: UILabel!

    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var thumbnailImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var thumbnailImageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!

    var placeholderImage: UIImage!

    private lazy var imageLoader = ImageLoader()

    private var imageRequest: Cancellable?

    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 13.0, *) {
            placeholderImage = ImageLoader.placeholderSFImage
        } else {
            placeholderImage = ImageLoader.placeholderImage
        }
        cleanupViews()
    }

    private func cleanupViews() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()

        thumbnailImageViewBottomConstraint.constant = 0
        thumbnailImageViewHeightConstraint.constant = 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cleanupViews()
        thumbnailImageView.image = nil

        // Cancel Image Request
        imageRequest?.cancel()
    }

    func configure(_ post: PostCellModel) {
        if let thumbnailHeight = post.thumbnailHeight, thumbnailHeight != 0, let thumbnailWidth = post.thumbnailWidth, thumbnailWidth != 0, let thumbnail = post.thumbnail, thumbnail != "self" {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            thumbnailImageViewBottomConstraint.constant = PostDetailTableViewCell.thumbnailImageViewDefaultBottom
            thumbnailImageViewHeightConstraint.constant = PostDetailTableViewCell.thumbnailImageViewDefaultHeight

            if let height = post.thumbnailHeight {
                thumbnailImageViewHeightConstraint.constant = CGFloat(height * 2)
                thumbnailImageView.contentMode = .scaleToFill
                thumbnailImageView.layer.cornerRadius = 8
                thumbnailImageView.layer.borderColor = UIColor.cyan.cgColor
                thumbnailImageView.layer.borderWidth = 1.0
            } else {
                thumbnailImageViewHeightConstraint.constant = PostDetailTableViewCell.thumbnailImageViewDefaultHeight
                thumbnailImageView.contentMode = .scaleAspectFit
            }

            thumbnailImageView.image = post.thumbnailImage
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true

            if post.thumbnailImage == placeholderImage {
                downloadThumbnail(for: post)
            }
        }
        postDescriptionLabel.text = post.description
    }

    /// Request Thumbnail Using Image Loader if image from news model is not a placeholder image
    private func downloadThumbnail(for post: PostCellModel) {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        imageRequest = imageLoader.loadImage(for: post, completion: { [weak self] fetchedNews, fetchedImage, imageDownloadError in
            self?.activityIndicatorView.stopAnimating()
            self?.activityIndicatorView.isHidden = true
            if imageDownloadError == nil {
                // update the model if the same image does not already exists for that post model
                if let img = fetchedImage, fetchedNews.thumbnailImage != img {
                    post.thumbnailImage = img
                    self?.thumbnailImageView.image = img
                    self?.thumbnailImageView.layer.borderWidth = 2.0
                }
            }
        })
    }
}

// MARK: - Identifiable Conformance for setting Reuse Identifier

extension PostDetailTableViewCell: Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
