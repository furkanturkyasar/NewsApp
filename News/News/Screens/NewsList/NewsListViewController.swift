//
//  NewsListViewController.swift
//  News
//
//  Created by Furkan Türkyaşar on 30.01.2025.
//

import UIKit

protocol NewsListOutputProtocol: AnyObject {
    func reloadData()
}

final class NewsListViewController: UIViewController {
    private let viewModel: NewsListViewModel = .init()
    private var page: Int = 1

    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let itemWidth = CGFloat.dWidth
        layout.itemSize = CGSize(width: itemWidth, height: 140)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            NewsListCollectionViewCell.self,
            forCellWithReuseIdentifier: NewsListCollectionViewCell.identifier
        )
        return collectionView
    }()

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
        navigationItem.title = NSLocalizedString("Tabbar.News", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        configureCollectionView()
    }

    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func configureSeparator(for cell: NewsListCollectionViewCell) {
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(separator)

        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 12),
            separator.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -12),
            separator.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: 20),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

// MARK: - CollectionView

extension NewsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        40
    }
}

extension NewsListViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.articles.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NewsListCollectionViewCell.identifier,
            for: indexPath
        ) as! NewsListCollectionViewCell
        configureSeparator(for: cell)
        let item = viewModel.articles[indexPath.item]
        cell.configure(with: item)
        return cell
    }
}

extension NewsListViewController: UIScrollViewDelegate, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        for indexPath in indexPaths {
//            viewModel.inputDelegate?.fetchMoreData(page: 1, query: nil)
//        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height

        if offsetY > contentHeight - scrollViewHeight - 100 {
            page += 1
            viewModel.inputDelegate?.fetchMoreData(page: page, query: nil)
        }
    }
}

// MARK: - NewsListOutputProtocol

extension NewsListViewController: NewsListOutputProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
