//
//  RSwiftRedditViewController.swift
//  r-Swift

import UIKit

// MARK: - RSwiftRedditViewController

class RSwiftRedditViewController: UIViewController {
    lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: .zero)
        _tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.estimatedRowHeight = Constants.CGFloatValue.k50
        _tableView.backgroundView = activityIndicator
        _tableView.rowHeight = UITableView.automaticDimension
        return _tableView
    }()

    lazy var retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Constants.CGFloatValue.k10
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(retryButtonAction(_:)), for: .touchUpInside)
        button.tag = Constants.CGFloatValue.k1.intValue
        button.setTitle(Constants.Button.Retry, for: .normal)
        return button
    }()

    weak var activityIndicator: UIActivityIndicatorView!

    static let operationQueue = OperationQueue()

    private var viewModel: RSwiftViewModel!

    // MARK: viewDidAppear

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if viewModel.posts.value?.isEmpty ?? true {
            let fetchRedditPostsOperation = BlockOperation {
//                Thread.sleep(forTimeInterval: 2.0)
                self.fetchRedditPostsForRSwift()
            }
            RSwiftRedditViewController.operationQueue.addOperation(fetchRedditPostsOperation)
        }
    }

    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = RSwiftViewModel()

        setupUI()
        bindViewModel()
    }

    // MARK: setupUI

    private func setupUI() {
        title = Constants.Strings.HomeTitle
        var activityIndicatorView: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        } else {
            // Fallback on earlier versions
            activityIndicatorView = UIActivityIndicatorView(style: .gray)
        }
        activityIndicator = activityIndicatorView

        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    // MARK: bindViewModel

    private func bindViewModel() {
        viewModel.posts.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: retryButtonAction

    @objc
    private func retryButtonAction(_ sender: UIButton!) {
        DispatchQueue.main.async { [weak self] in
            self?.manageRetryButton(shouldRemove: true)
            self?.fetchRedditPostsForRSwift()
        }
    }

    // MARK: manageRetryButton

    private func manageRetryButton(shouldRemove: Bool) {
        if shouldRemove, view.subviews.contains(retryButton) {
            retryButton.removeFromSuperview()
        } else if !shouldRemove {
            view.addSubview(retryButton)

            NSLayoutConstraint.activate([
                retryButton.heightAnchor.constraint(equalToConstant: Constants.CGFloatValue.k44),
                retryButton.widthAnchor.constraint(equalToConstant: Constants.ScreenSize.Width * Constants.CGFloatValue.kPoint3),
                retryButton.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
                retryButton.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
            ])
        }
    }

    // MARK: fetchRedditPostsForRSwift

    private func fetchRedditPostsForRSwift() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        viewModel.loadRedditPosts(onError: { [weak self] error in
            if error {
                DispatchQueue.main.async {
                    self?.showCustomAlert()
                }
            } else {
                DispatchQueue.main.async {
                    self?.manageRetryButton(shouldRemove: true)
                }
            }
        })
    }

    // MARK: showCustomAlert

    private func showCustomAlert() {
        // display error
        let controller = UIAlertController(title: Constants.Error.Title, message: Constants.Error.Message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: Constants.Button.Close, style: .cancel, handler: { [weak self] _ in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.manageRetryButton(shouldRemove: false)
            }
        }))
        controller.addAction(UIAlertAction(title: Constants.Button.Retry, style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                self?.manageRetryButton(shouldRemove: true)
                self?.fetchRedditPostsForRSwift()
            }
        }))
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension RSwiftRedditViewController: UITableViewDataSource {
    // MARK: numberOfSections

    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.CGFloatValue.k1.intValue
    }

    // MARK: numberOfRowsInSection

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.value?.count ?? Constants.CGFloatValue.k0.intValue
    }

    // MARK: cellForRowAt

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell, let post = viewModel.posts.value?[indexPath.row] else { return UITableViewCell() }

        cell.configure(post)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RSwiftRedditViewController: UITableViewDelegate {
    // MARK: didSelectRowAt

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let post = viewModel.posts.value?[indexPath.row] else { return }
        let storyboard = UIStoryboard(name: Constants.Storyboard.Main, bundle: nil)
        let postDetailsViewController = storyboard.instantiateViewController(withIdentifier: PostDetailsViewController.identifier) as! PostDetailsViewController
        postDetailsViewController.post = post

        navigationController?.pushViewController(postDetailsViewController, animated: true)
    }
}
