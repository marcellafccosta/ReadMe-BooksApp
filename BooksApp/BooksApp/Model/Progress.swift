//
//  Progress.swift
//  BooksApp
//
//  Created by 2213dtidigital on 21/07/25.
//

import Foundation
import SwiftData

@Model
class ReadingProgress {
    var id: String
    var title: String
    var coverURL: String?
    var currentPage: Int
    var pageCount: Int?
    var lastUpdated: Date
    
    @Relationship(deleteRule: .cascade, inverse: \Annotation.progress)
      var annotations: [Annotation] = []
    
    init(id: String, title: String, coverURL: String?, currentPage: Int = 0, pageCount: Int?) {
        self.id = id
        self.title = title
        self.coverURL = coverURL
        self.currentPage = currentPage
        self.pageCount = pageCount
        self.lastUpdated = Date()
    }
}

extension ReadingProgress {
    func asBook() -> Book {
        Book(
            id: self.id,
            volumeInfo: VolumeInfo(
                title: self.title,
                authors: [],
                publisher: nil,
                publishedDate: nil,
                description: nil,
                pageCount: self.pageCount,
                categories: nil,
                imageLinks: ImageLinks(
                    smallThumbnail: nil,
                    thumbnail: self.coverURL
                ),
                industryIdentifiers: nil
            )
        )
    }
}
