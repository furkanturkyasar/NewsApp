//
//  NewsService.swift
//  News
//
//  Created by Furkan Türkyaşar on 30.01.2025.
//

import Foundation

final class NewsService {
    static let shared = NewsService()
    private init() {}

    func fetchTopHeadlines(page: Int = 1, query: String? = nil, completion: @escaping (Result<News, Error>) -> Void) {
        let endPoint = URLs.allNews(page: page, q: query)

        NetworkManager.shared.request(endPoint) { (result: Result<News, Error>) in
            switch result {
            case .success(let newsResponse):
                completion(.success(newsResponse))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
