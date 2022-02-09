//
//  RSwiftRedditViewController.swift
//  r-Swift
//
//  Created by Sachin Ambegave on 10/02/22.
//

import UIKit

class RSwiftRedditViewController: UIViewController {
    lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: .zero)
        _tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.estimatedRowHeight = 50
        _tableView.backgroundView = activityIndicator
        _tableView.rowHeight = UITableView.automaticDimension
        return _tableView
    }()

    weak var activityIndicator: UIActivityIndicatorView!

    static let operationQueue = OperationQueue()

    private var viewModel: RSwiftViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = RSwiftViewModel()

        setupUI()
        bindViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if viewModel.posts.value?.isEmpty ?? true {
            let fetchRedditPostsOperation = BlockOperation {
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
//                Thread.sleep(forTimeInterval: 2.0)
                self.fetchRedditPostsForRSwift()
            }
            RSwiftRedditViewController.operationQueue.addOperation(fetchRedditPostsOperation)
        }
    }

    private func setupUI() {
        title = "Swift News"
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

    private func bindViewModel() {
        viewModel.posts.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
    }

    private func fetchRedditPostsForRSwift() {
        viewModel.loadRedditPosts(onError: { [weak self] error in
            if error {
                DispatchQueue.main.async {
                    self?.showCustomAlert()
                }
            }
        })
    }

    private func showCustomAlert() {
        // display error
        let title = "An error occurred"
        let message = "Oops, something went wrong!"

        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        controller.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
            self.fetchRedditPostsForRSwift()
        }))
        present(controller, animated: true, completion: nil)
    }
}

extension RSwiftRedditViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell, let post = viewModel.posts.value?[indexPath.row] else { return UITableViewCell() }

        cell.configure(post)
        return cell
    }
}
