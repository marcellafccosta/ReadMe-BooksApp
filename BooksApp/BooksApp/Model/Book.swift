//
//  Book.swift
//  BooksApp
//
//  Created by 2213dtidigital on 16/06/25.
//

import Foundation

struct Book: Codable, Identifiable {
    let id: String
    let volumeInfo: VolumeInfo
    var title: String {
        volumeInfo.title
    }
    var coverURL: URL? {
        if let urlString = volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http://", with: "https://") {
            return URL(string: urlString)
        }
        return nil
    }
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let pageCount: Int?
    let categories: [String]?
    let imageLinks: ImageLinks?
    let industryIdentifiers: [IndustryIdentifier]?
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

struct IndustryIdentifier: Codable {
    let type: String
    let identifier: String
}

struct Paging: Codable {
    let items: [Book]
    let totalItems: Int
}
