//
//  PostDetailTableViewCell.swift
//  r-Swift

import UIKit

// MARK: - PostDetailTableViewCell

class PostDetailTableViewCell: UITableViewCell {
    private static var thumbnailImageViewDefaultBottom: CGFloat = Constants.CGFloatValue.k8
    private static var thumbnailImageViewDefaultHeight: CGFloat = Constants.CGFloatValue.k80

    @IBOutlet private var postDescriptionLabel: UILabel!

    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var thumbnailImageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var thumbnailImageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!

    var placeholderImage: UIImage!

    private lazy var imageLoader = ImageLoader()

    private var imageRequest: Cancellable?

    // MARK: awakeFromNib

    override func awakeFromNib() {
        super.awakeFromNib()
        if #available(iOS 13.0, *) {
            placeholderImage = ImageLoader.placeholderSFImage
        } else {
            placeholderImage = ImageLoader.placeholderImage
        }
        cleanupViews()
    }

    // MARK: prepareForReuse

    override func prepareForReuse() {
        super.prepareForReuse()
        cleanupViews()
        thumbnailImageView.image = nil

        // Cancel Image Request
        imageRequest?.cancel()
    }

    // MARK: cleanupViews

    private func cleanupViews() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()

        thumbnailImageViewBottomConstraint.constant = Constants.CGFloatValue.k0
        thumbnailImageViewHeightConstraint.constant = Constants.CGFloatValue.k0
    }

    // MARK: configure

    func configure(_ post: PostCellModel) {
        let k0 = Constants.CGFloatValue.k0.intValue
        if let thumbnailHeight = post.thumbnailHeight, thumbnailHeight != k0, let thumbnailWidth = post.thumbnailWidth, thumbnailWidth != k0, let thumbnail = post.thumbnail, thumbnail != Constants.Strings.Self {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            thumbnailImageViewBottomConstraint.constant = PostDetailTableViewCell.thumbnailImageViewDefaultBottom
            thumbnailImageViewHeightConstraint.constant = PostDetailTableViewCell.thumbnailImageViewDefaultHeight

            if let height = post.thumbnailHeight {
                thumbnailImageViewHeightConstraint.constant = CGFloat(height * Constants.CGFloatValue.k2.intValue)
                thumbnailImageView.contentMode = .scaleToFill
                thumbnailImageView.layer.cornerRadius = Constants.CGFloatValue.k8
                thumbnailImageView.layer.borderColor = UIColor.cyan.cgColor
                thumbnailImageView.layer.borderWidth = Constants.CGFloatValue.k1
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

    // MARK: downloadThumbnail

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
                    self?.thumbnailImageView.layer.borderWidth = Constants.CGFloatValue.k2
                }
            }
        })
    }
}

// MARK: - Identifiable

extension PostDetailTableViewCell: Identifiable {
    /// Identifiable Conformance for setting Reuse Identifier
    static var identifier: String {
        return String(describing: self)
    }
}
