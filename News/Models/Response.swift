//
//	Response
//  News
//	Created by: @nedimf on 29/04/2022


import Foundation

// MARK: - Response
struct Response: Codable {
    let status: String?
    let totalResults: Int
    let headlines: [Headline]?
    
    enum CodingKeys: String, CodingKey {
        case status, totalResults
        case headlines = "articles"
    }
}

// MARK: - Headline
struct Headline: Codable {
    let id = UUID()
    let source: Source?
    let author, title, articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source, author, title
        case articleDescription = "description"
        case url, urlToImage, publishedAt, content
    }
}

// MARK: - Source
struct Source: Codable {
    let id, name: String?
}
