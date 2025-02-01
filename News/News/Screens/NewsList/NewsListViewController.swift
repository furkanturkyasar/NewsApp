//
//  NewsListViewController.swift
//  News
//
//  Created by Furkan Türkyaşar on 30.01.2025.
//

import UIKit

protocol NewsListOutputProtocol: AnyObject {}

final class NewsListViewController: UIViewController {

    private let viewModel: NewsListViewModel = .init()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.outputDelegate = self
        setupUI()
    }
}

// MARK: - Private Methods

private extension NewsListViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
    }
}

// MARK: - NewsListOutputProtocol

extension NewsListViewController: NewsListOutputProtocol {}
