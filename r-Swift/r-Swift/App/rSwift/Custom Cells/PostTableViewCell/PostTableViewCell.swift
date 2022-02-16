//
//  PostTableViewCell.swift
//  r-Swift

import UIKit

// MARK: - PostTableViewCell

class PostTableViewCell: UITableViewCell {
    private static var thumbnailImageViewDefaultTop: CGFloat = Constants.CGFloatValue.k8
    private static var thumbnailImageViewDefaultBottom: CGFloat = Constants.CGFloatValue.k8
    private static var thumbnailImageViewMaxHeight: Int = Constants.CGFloatValue.k200.intValue
    private static var thumbnailImageViewMinHeight: Int = Constants.CGFloatValue.k44.intValue
    private static var thumbnailImageViewDefaultHeight: CGFloat = Constants.CGFloatValue.k80

    private static var awardsCollectionViewDefaultTop: CGFloat = Constants.CGFloatValue.k4
    private static var awardsCollectionViewDefaultBottom: CGFloat = Constants.CGFloatValue.k8
    private static var awardsCollectionViewDefaultHeight: CGFloat = Constants.CGFloatValue.k40
    private static var awardsCollectionViewMaxWidth: CGFloat = (Constants.ScreenSize.Width - Constants.CGFloatValue.k32)

    private static var awardsIconDefaultHeight: CGFloat = Constants.CGFloatValue.k35
    private static var awardsIconDefaultWidth: CGFloat = Constants.CGFloatValue.k35

    @IBOutlet private var postTitleLabel: UILabel!

    @IBOutlet private var thumbnailImageContainerView: UIView!
    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var thumbnailImageViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet private var awardsCollectionContainerView: UIView!
    @IBOutlet private var awardsCollectionView: UICollectionView!
    @IBOutlet private var awardsCollectionViewWidthConstraint: NSLayoutConstraint!

    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!

    var placeholderImage: UIImage!

    var awards: [PostAward]? = []

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
    }

    // MARK: cleanupViews

    private func cleanupViews() {
        activityIndicatorView.isHidden = true
        activityIndicatorView.stopAnimating()

        thumbnailImageContainerView.isHidden = true
        awardsCollectionContainerView.isHidden = true
    }

    // MARK: configure

    func configure(_ post: PostCellModel) {
        var hasThumbnail = false
        var hasAward = false

        checkIfHasAwards(for: post, &hasAward)
        checkIfHasThumbnail(for: post, &hasThumbnail)

        postTitleLabel.text = post.title
    }

    // MARK: checkIfHasThumbnail

    private func checkIfHasThumbnail(for post: PostCellModel, _ hasThumbnail: inout Bool) {
        let k0 = Constants.CGFloatValue.k0.intValue
        if let thumbnailHeight = post.thumbnailHeight, thumbnailHeight != k0, let thumbnailWidth = post.thumbnailWidth, thumbnailWidth != k0, let thumbnail = post.thumbnail, thumbnail != Constants.Strings.Self {
            hasThumbnail = true
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            if let height = post.thumbnailHeight, height != k0, let width = post.thumbnailWidth, width != k0 {
                let imageHeight = height < PostTableViewCell.thumbnailImageViewMinHeight ? PostTableViewCell.thumbnailImageViewMinHeight : (height > PostTableViewCell.thumbnailImageViewMaxHeight ? PostTableViewCell.thumbnailImageViewMaxHeight : height * Constants.CGFloatValue.k2.intValue)

                thumbnailImageViewHeightConstraint.constant = CGFloat(imageHeight)
                thumbnailImageView.contentMode = .scaleToFill
                thumbnailImageView.layer.cornerRadius = Constants.CGFloatValue.k8
                thumbnailImageView.layer.borderColor = UIColor.cyan.cgColor
                thumbnailImageView.layer.borderWidth = Constants.CGFloatValue.k1
                thumbnailImageContainerView.isHidden = false
            } else {
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

    // MARK: checkIfHasAwards

    private func checkIfHasAwards(for post: PostCellModel, _ hasAward: inout Bool) {
        if let allAwards = post.allAwards, !allAwards.isEmpty {
            hasAward = true
            awards = allAwards
            awardsCollectionContainerView.isHidden = false
            setupAwardCollectionView()
            awardsCollectionView.layer.cornerRadius = Constants.CGFloatValue.k8
            awardsCollectionView.layer.borderColor = UIColor.gray.cgColor
            awardsCollectionView.layer.borderWidth = Constants.CGFloatValue.k1

            let collectionViewCustomWidth = CGFloat(allAwards.count * Constants.CGFloatValue.k44.intValue)
            awardsCollectionViewWidthConstraint.constant = (collectionViewCustomWidth < PostTableViewCell.awardsCollectionViewMaxWidth) ? collectionViewCustomWidth : PostTableViewCell.awardsCollectionViewMaxWidth
        }
    }

    // MARK: setupAwardCollectionView

    private func setupAwardCollectionView() {
        awardsCollectionView.register(UINib(nibName: AwardCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AwardCollectionViewCell.identifier)
        awardsCollectionView.dataSource = self
        let spacing = Constants.CGFloatValue.k10
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let k2 = Constants.CGFloatValue.k2
        layout.sectionInset = UIEdgeInsets(top: spacing / k2, left: spacing / k2, bottom: spacing / k2, right: spacing / k2)
        layout.minimumLineSpacing = Constants.CGFloatValue.k8
        layout.minimumInteritemSpacing = Constants.CGFloatValue.k0
        layout.itemSize = CGSize(width: PostTableViewCell.awardsIconDefaultWidth, height: PostTableViewCell.awardsIconDefaultHeight)
        awardsCollectionView.collectionViewLayout = layout
        awardsCollectionView.showsHorizontalScrollIndicator = false
    }

    // MARK: downloadThumbnail

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
                    self?.thumbnailImageView.layer.borderWidth = Constants.CGFloatValue.k2
                }
            }
        })
    }
}

// MARK: - Identifiable

extension PostTableViewCell: Identifiable {
    /// Identifiable Conformance for setting Reuse Identifier
    static var identifier: String {
        return String(describing: self)
    }
}
