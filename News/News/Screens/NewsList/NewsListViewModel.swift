//
//  NewsListViewModel.swift
//  News
//
//  Created by Furkan Türkyaşar on 30.01.2025.
//

import Foundation

protocol NewsListInputProtocol: AnyObject {
    func fetchMoreData(page: Int, query: String?)
}

final class NewsListViewModel {
    private let newsService = NewsService.shared
    private(set) var articles: [Article] = []
    var news: News!

    weak var inputDelegate: NewsListInputProtocol?
    weak var outputDelegate: NewsListOutputProtocol?

    init() {
        inputDelegate = self

        refreshData()
    }

    func fetchTopHeadlines(page: Int = 1, query: String? = nil, completion: @escaping () -> Void) {
        newsService.fetchTopHeadlines(page: page, query: query) { [weak self] result in
            switch result {
            case .success(let news):
                self?.news = news
                self?.articles = news.articles
                completion()

            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }

    func refreshData() {
        fetchTopHeadlines {
            print("triggered !")
            self.outputDelegate?.reloadData()
        }
    }
}

// MARK: - NewsListInputProtocol

extension NewsListViewModel: NewsListInputProtocol {
    func fetchMoreData(page: Int = 1, query: String?) {
        let page = Int(ceil(Double(page)))

        if let news = self.news {
            if page <= news.totalResults / 20 {
                fetchTopHeadlines(page: page, query: query) {
                    self.refreshData()
                }
            }
        }
    }
}
