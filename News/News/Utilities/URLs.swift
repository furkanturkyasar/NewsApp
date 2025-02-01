//
//  URLs.swift
//  News
//
//  Created by Furkan Türkyaşar on 30.01.2025.
//

import Foundation

enum URLs {
    static func allNews(page: Int = 1, q: String? = "") -> String {
        let apiKey = ProcessInfo.processInfo.environment["API_KEY"] ?? ""
        var baseUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(apiKey)&page=\(page)"

        if let q = q, !q.isEmpty {
            baseUrl += "&q=\(q)"
        }
        print("base url: \(baseUrl)")
        return baseUrl
    }
}
