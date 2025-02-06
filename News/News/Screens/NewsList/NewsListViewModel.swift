//
//  NewsListViewModel.swift
//  News
//
//  Created by Furkan Türkyaşar on 30.01.2025.
//

import Foundation

protocol NewsListInputProtocol: AnyObject {
    func fetchMoreData()
}

final class NewsListViewModel {
    private let newsService = NewsService.shared
    private(set) var articles: [Article] = []
    private var page: Int = 1
    var query: String?
    private var isLoading: Bool = false
    var news: News!

    private var debounceWorkItem: DispatchWorkItem?

    weak var inputDelegate: NewsListInputProtocol?
    weak var outputDelegate: NewsListOutputProtocol?

    init() {
        inputDelegate = self

        fetchData()
    }

    func fetchTopHeadlines(page: Int = 1, query: String? = nil, completion: @escaping () -> Void) {
        guard !isLoading else { return }

        newsService.fetchTopHeadlines(page: page, query: query) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let news):
                self.news = news
                self.articles.append(contentsOf: news.articles)
                completion()

            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }

            self.isLoading = false
        }
    }

    func fetchData() {
        page = 1
        articles.removeAll()
        debounceWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            self?.fetchTopHeadlines(page: self?.page ?? 1, query: self?.query) {
                DispatchQueue.main.async {
                    self?.outputDelegate?.reloadData()
                }
            }
        }

        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}

// MARK: - NewsListInputProtocol

extension NewsListViewModel: NewsListInputProtocol {
    func fetchMoreData() {
        if let news = self.news {
            let totalPages = Int(ceil(Double(news.totalResults) / 20.0))

            if page < totalPages, articles.count < news.totalResults, !isLoading {
                page += 1
                fetchTopHeadlines(page: page, query: query) {
                    self.outputDelegate?.reloadData()
                }
            }
        }
    }
}
