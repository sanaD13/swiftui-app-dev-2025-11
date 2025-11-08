//
//  APIClient.swift
//  VideoPlayer
//
//  Created by Sana Desai on 2025-11-07.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}

final class APIClient {
    private let baseURL: URL
    
    // initialize with the base URL provided by the client
    init(baseURL: URL = URL(string: "http://localhost:4000")!) {
        self.baseURL = baseURL
    }

    func fetchVideos(completion: @escaping (Result<[Video], APIError>) -> Void) {
        let url = baseURL.appendingPathComponent("videos")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let e = error {
                completion(.failure(.requestFailed(e))); return
            }
            guard let data = data else {
                completion(.failure(.invalidResponse)); return
            }
            do {
                let decoder = JSONDecoder.videoDecoder()
                let videos = try decoder.decode([Video].self, from: data)
                completion(.success(videos))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
}
