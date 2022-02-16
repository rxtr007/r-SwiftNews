//
//  PostDetailsViewController.swift
//  r-Swift

import UIKit

// MARK: - PostDetailsViewController

class PostDetailsViewController: UIViewController {
    lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: .zero)
        _tableView.register(UINib(nibName: PostDetailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostDetailTableViewCell.identifier)
        _tableView.dataSource = self
        _tableView.separatorStyle = .none
        _tableView.estimatedRowHeight = Constants.CGFloatValue.k200
        _tableView.rowHeight = UITableView.automaticDimension
        return _tableView
    }()

    weak var post: PostCellModel?

    // MARK: viewDidAppear

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let post = post else { return }

        title = post.title

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
}

// MARK: - UITableViewDataSource

extension PostDetailsViewController: UITableViewDataSource {
    // MARK: numberOfSections

    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.CGFloatValue.k1.intValue
    }

    // MARK: numberOfRowsInSection

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.CGFloatValue.k1.intValue
    }

    // MARK: cellForRowAt

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewCell.identifier, for: indexPath) as? PostDetailTableViewCell, let post = self.post else { return UITableViewCell() }

        cell.configure(post)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Identifiable

extension PostDetailsViewController: Identifiable {
    /// Identifiable Conformance for setting identifier
    static var identifier: String {
        return String(describing: self)
    }
}
