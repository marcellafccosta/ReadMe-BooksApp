//
//  Favorites.swift
//  BooksApp
//
//  Created by 2213dtidigital on 18/06/25.
//

import Foundation
import SwiftData

@Model
class FavoriteBook {
    var id: String
    var title: String
    var coverURL: String?
    var dateAdded: Date
    var authorsRaw: String?
    var publisher: String?
    var publishedDate: String?
    var bookDescription: String?
    var pageCount: Int?
    var categoriesRaw: String?
    
    init(id: String, title: String, coverURL: String?, authors: [String]? = nil, publisher: String? = nil, publishedDate: String? = nil, description: String? = nil, pageCount: Int? = nil, categories: [String]? = nil) {
        self.id = id
        self.title = title
        self.coverURL = coverURL
        self.dateAdded = Date()
        self.authorsRaw = authors?.joined(separator: ",")
        self.publisher = publisher
        self.publishedDate = publishedDate
        self.bookDescription = description
        self.pageCount = pageCount
        self.categoriesRaw = categories?.joined(separator: ",")
    }
}

extension FavoriteBook {
    var authors: [String]? {
        authorsRaw?.components(separatedBy: ",")
    }
    
    var categories: [String]? {
        categoriesRaw?.components(separatedBy: ",")
    }
    
    func asBook() -> Book {
        Book(
            id: self.id,
            volumeInfo: VolumeInfo(
                title: self.title,
                authors: self.authors,
                publisher: self.publisher,
                publishedDate: self.publishedDate,
                description: self.bookDescription,
                pageCount: self.pageCount,
                categories: self.categories,
                imageLinks: self.coverURL != nil ?
                ImageLinks(smallThumbnail: nil, thumbnail: self.coverURL) : nil,
                industryIdentifiers: nil
            )
        )
    }
}
