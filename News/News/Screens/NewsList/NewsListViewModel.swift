//
//  NewsListViewModel.swift
//  News
//
//  Created by Furkan Türkyaşar on 30.01.2025.
//

import Foundation

protocol NewsListInputProtocol: AnyObject {}

final class NewsListViewModel {
    private let newsService = NewsService.shared
    var articles: [Article] = []

    weak var inputDelegate: NewsListInputProtocol?
    weak var outputDelegate: NewsListOutputProtocol?

    init() {
        inputDelegate = self

        fetchTopHeadlines {
            print("news fetch completed!")
        }
    }

    func fetchTopHeadlines(page: Int = 1, query: String? = nil, completion: @escaping () -> Void) {
        newsService.fetchTopHeadlines(page: page, query: query) { [weak self] result in
            switch result {
            case .success(let news):
                self?.articles = news.articles
                completion()

            case .failure(let error):
                print("Hata: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - NewsListInputProtocol

extension NewsListViewModel: NewsListInputProtocol {}
