//
//  Video.swift
//  VideoPlayer
//
//  Created by Sana Desai on 2025-11-07.
//

import Foundation

struct Video: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let hlsURL: URL
    let fullURL: URL
    let publishedAt: Date
    let author: Author

    // Computed properties
    var playbackURL: URL { fullURL } // can switch to hlsURL if needed
    var authorName: String { author.name }

    enum CodingKeys: String, CodingKey {
        case id, title, description, hlsURL, fullURL, publishedAt, author
    }
}

struct Author: Codable, Identifiable {
    let id: String
    let name: String
}

extension JSONDecoder {
    static func videoDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
