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
        navigationItem.searchController?.searchBar.delegate = self
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
        let nextPageTrigger = viewModel.articles.count - 5
        if indexPaths.contains(where: { $0.item >= nextPageTrigger }) {
            viewModel.inputDelegate?.fetchMoreData()
        }
    }
}

// MARK: - SearchBar

extension NewsListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.query = nil
            viewModel.fetchData()
        }
        guard searchText.count >= 3 else {
            return
        }
        if searchText.isEmpty {
            viewModel.query = nil
            viewModel.fetchData()
        }
        viewModel.query = searchText
        viewModel.fetchData()
    }
}

// MARK: - NewsListOutputProtocol

extension NewsListViewController: NewsListOutputProtocol {
    func reloadData() {
        DispatchQueue.main.async {
            UIView.transition(with: self.collectionView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.collectionView.reloadData()
            }, completion: nil)
        }
    }
}
