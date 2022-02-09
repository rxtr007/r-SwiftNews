//
//  PostTableViewCell.swift
//  r-Swift
//
//  Created by Sachin Ambegave on 10/02/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    private static var thumbnailImageViewDefaultTop: CGFloat = 8
    private static var thumbnailImageViewDefaultBottom: CGFloat = 8
    private static var thumbnailImageViewDefaultHeight: CGFloat = 80

    private static var awardsCollectionViewDefaultTop: CGFloat = 4
    private static var awardsCollectionViewDefaultBottom: CGFloat = 8
    private static var awardsCollectionViewDefaultHeight: CGFloat = 40
    private static var awardsCollectionViewMaxWidth: CGFloat = (UIScreen.main.bounds.width - 32)

    private static var awardsIconDefaultHeight: CGFloat = 35
    private static var awardsIconDefaultWidth: CGFloat = 35

    @IBOutlet private var postTitleLabel: UILabel!

    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var thumbnailImageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var thumbnailImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var thumbnailImageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet private var awardsCollectionView: UICollectionView!
    @IBOutlet private var awardsCollectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var awardsCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var awardsCollectionViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!

    var placeholderImage: UIImage!

    var awards: [PostAward]? = []

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

    override func prepareForReuse() {
        super.prepareForReuse()
        cleanupViews()
        thumbnailImageView.image = nil
    }

    private func cleanupViews() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()

        awardsCollectionViewBottomConstraint.constant = 0
        awardsCollectionViewHeightConstraint.constant = 0
        awardsCollectionViewWidthConstraint.constant = 0

        thumbnailImageViewTopConstraint.constant = 0
        thumbnailImageViewBottomConstraint.constant = 0
        thumbnailImageViewHeightConstraint.constant = 0
    }

    func configure(_ post: PostCellModel) {
        var hasThumbnail = false
        var hasAward = false

        checkIfHasAwards(for: post, &hasAward)
        checkIfHasThumbnail(for: post, &hasThumbnail)

        if hasThumbnail, hasAward {
            thumbnailImageViewBottomConstraint.constant = PostTableViewCell.awardsCollectionViewDefaultTop
        } else if !hasThumbnail, !hasAward {
            thumbnailImageViewTopConstraint.constant = PostTableViewCell.thumbnailImageViewDefaultTop
        }

        postTitleLabel.text = post.title
    }

    private func checkIfHasThumbnail(for post: PostCellModel, _ hasThumbnail: inout Bool) {
        if let thumbnailHeight = post.thumbnailHeight, thumbnailHeight != 0, let thumbnailWidth = post.thumbnailWidth, thumbnailWidth != 0, let thumbnail = post.thumbnail, thumbnail != "self" {
            hasThumbnail = true
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            thumbnailImageViewTopConstraint.constant = PostTableViewCell.thumbnailImageViewDefaultTop
            thumbnailImageViewBottomConstraint.constant = PostTableViewCell.thumbnailImageViewDefaultBottom
            if let height = post.thumbnailHeight {
                thumbnailImageViewHeightConstraint.constant = CGFloat(height * 2)
                thumbnailImageView.contentMode = .scaleToFill
                thumbnailImageView.layer.cornerRadius = 8
                thumbnailImageView.layer.borderColor = UIColor.cyan.cgColor
                thumbnailImageView.layer.borderWidth = 1.0
            } else {
                thumbnailImageViewHeightConstraint.constant = PostTableViewCell.thumbnailImageViewDefaultHeight
                thumbnailImageView.contentMode = .scaleAspectFit
            }
            thumbnailImageView.image = post.thumbnailImage
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true

            if post.thumbnailImage == placeholderImage {
                // Download Image
                downloadThumbnail(for: post)
            }
        }
    }

    private func checkIfHasAwards(for post: PostCellModel, _ hasAward: inout Bool) {
        if let allAwards = post.allAwards, !allAwards.isEmpty {
            hasAward = true
            awards = allAwards
            awardsCollectionView.layer.cornerRadius = 8
            awardsCollectionView.layer.borderColor = UIColor.gray.cgColor
            awardsCollectionView.layer.borderWidth = 1.0

            let collectionViewCustomWidth = CGFloat(allAwards.count * 44)
            awardsCollectionViewWidthConstraint.constant = (collectionViewCustomWidth < PostTableViewCell.awardsCollectionViewMaxWidth) ? collectionViewCustomWidth : PostTableViewCell.awardsCollectionViewMaxWidth
            thumbnailImageViewBottomConstraint.constant = PostTableViewCell.awardsCollectionViewDefaultTop
            awardsCollectionViewBottomConstraint.constant = PostTableViewCell.awardsCollectionViewDefaultBottom
            awardsCollectionViewHeightConstraint.constant = PostTableViewCell.awardsCollectionViewDefaultHeight
        }
    }

    /// Request Thumbnail Using Image Loader if image from post model is not a placeholder image
    private func downloadThumbnail(for post: PostCellModel) {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        imageRequest = imageLoader.loadImage(for: post, completion: { [weak self] fetchedPost, fetchedImage, imageDownloadError in
            self?.activityIndicatorView.stopAnimating()
            self?.activityIndicatorView.isHidden = true
            if imageDownloadError == nil {
                // update the model if the same image does not already exists for that post model
                if let img = fetchedImage, fetchedPost.thumbnailImage != img {
                    post.thumbnailImage = img
                    self?.thumbnailImageView.image = img
                    self?.thumbnailImageView.layer.borderWidth = 2.0
                }
            }
        })
    }
}

// MARK: - Identifiable Conformance for setting Reuse Identifier

extension PostTableViewCell: Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
