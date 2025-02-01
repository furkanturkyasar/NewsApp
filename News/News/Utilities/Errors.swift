//
//  Errors.swift
//  News
//
//  Created by Furkan Türkyaşar on 1.02.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
}
