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
        _tableView.estimatedRowHeight = 50
        _tableView.backgroundView = activityIndicator
        _tableView.rowHeight = UITableView.automaticDimension
        return _tableView
    }()
    
    weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
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
}
