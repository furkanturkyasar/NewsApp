//
//  NetworkManager.swift
//  News
//
//  Created by Furkan Türkyaşar on 30.01.2025.
//

import Foundation

final class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    func request<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        if let parameters = parameters, method == "POST" {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
