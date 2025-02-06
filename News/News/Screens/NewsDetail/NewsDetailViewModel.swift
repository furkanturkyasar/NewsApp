//
//  NewsDetailViewModel.swift
//  News
//
//  Created by Furkan Türkyaşar on 6.02.2025.
//

import Foundation

protocol NewsDetailInputProtocol: AnyObject {}

final class NewsDetailViewModel {
    private(set) var article: Article

    weak var inputDelegate: NewsDetailInputProtocol?
    weak var outputDelegate: NewsDetailOutputProtocol?

    init(article: Article) {
        self.article = article
        inputDelegate = self
    }
}

// MARK: - NewsDetailInputProtocol

extension NewsDetailViewModel: NewsDetailInputProtocol {}
