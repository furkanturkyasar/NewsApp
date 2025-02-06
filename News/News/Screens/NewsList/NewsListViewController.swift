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

    private let emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("no_news", comment: "")
        label.textAlignment = .center
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
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
        configureLoadingIndicator()
        configureEmptyView()
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

    func configureEmptyView() {
        view.addSubview(emptyView)
        emptyView.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emptyView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),

            emptyLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor)
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = viewModel.articles[indexPath.row]
        let detailVC = NewsDetailViewController(article: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func configureLoadingIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.color = .label
        activityIndicator.startAnimating()

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }

    func updateUI() {
        if viewModel.isLoading {
            activityIndicator.startAnimating()
            emptyView.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            if viewModel.articles.isEmpty {
                emptyView.isHidden = false
            } else {
                emptyView.isHidden = true
            }
        }
    }
}

extension NewsListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let nextPageTrigger = viewModel.articles.count - 3
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
            self.updateUI()
            UIView.transition(with: self.collectionView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.collectionView.reloadData()
            }, completion: nil)
        }
    }
}
