//
//  PostDetailsViewController.swift
//  r-Swift
//
//  Created by Sachin Ambegave on 10/02/22.
//

import UIKit

class PostDetailsViewController: UIViewController {
    lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: .zero)
        _tableView.register(UINib(nibName: PostDetailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostDetailTableViewCell.identifier)
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.separatorStyle = .none
        _tableView.estimatedRowHeight = 200
        _tableView.rowHeight = UITableView.automaticDimension
        return _tableView
    }()

    weak var post: PostCellModel?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let post = post else { return }

        title = post.title

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }
}

extension PostDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostDetailTableViewCell.identifier, for: indexPath) as? PostDetailTableViewCell, let post = self.post else { return UITableViewCell() }

        cell.configure(post)
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - Identifiable Conformance for setting identifier

extension PostDetailsViewController: Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
