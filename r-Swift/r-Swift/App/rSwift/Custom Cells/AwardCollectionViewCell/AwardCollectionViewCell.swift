//
//  AwardCollectionViewCell.swift
//  r-Swift

import UIKit

// MARK: - AwardCollectionViewCell

class AwardCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var awardImageView: UIImageView!

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

        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()
    }

    // MARK: prepareForReuse

    override func prepareForReuse() {
        super.prepareForReuse()
        awardImageView.image = nil

        // Cancel Image Request
        imageRequest?.cancel()
    }

    // MARK: configure

    func configure(_ award: PostAward) {
        awardImageView.contentMode = .scaleAspectFit
        awardImageView.image = award.icon
        activityIndicatorView.stopAnimating()
        activityIndicatorView.isHidden = true

        if let _ = award.iconURLString {
            /// Request Image Using Image Loader if image from award model is not a placeholder image
            if award.icon == placeholderImage {
                activityIndicatorView.startAnimating()
                activityIndicatorView.isHidden = false
                downloadIcon(for: award)
            }
        }
    }

    // MARK: downloadIcon

    /// Request Thumbnail Using Image Loader if image from post model is not a placeholder image
    private func downloadIcon(for award: PostAward) {
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        imageRequest = imageLoader.loadImage(for: award, completion: { [weak self] fetchedAward, fetchedImage, imageDownloadError in
            self?.activityIndicatorView.stopAnimating()
            self?.activityIndicatorView.isHidden = true
            if imageDownloadError == nil {
                // update the model if the same image does not already exists for that movie model
                if let img = fetchedImage, fetchedAward.icon != img {
                    award.icon = img
                    self?.awardImageView.image = img
                }
            }
        })
    }
}

// MARK: - Identifiable

extension AwardCollectionViewCell: Identifiable {
    /// Identifiable Conformance for setting Reuse Identifier
    static var identifier: String {
        return String(describing: self)
    }
}
