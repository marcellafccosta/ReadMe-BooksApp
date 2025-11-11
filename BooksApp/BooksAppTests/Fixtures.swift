//
//  Fixtures.swift
//  BooksAppTests
//
//  Created by 2213dtidigital on 04/07/25.
//

import Foundation
@testable import BooksApp

extension Paging {
    static var fixture: Paging {
        fixture()
    }
    
    static func fixture(
        totalItems: Int = 1,
        items: [Book] = [.fixture]
    ) -> Paging {
        Paging(items: items, totalItems: totalItems)
    }
}

extension Book {
    static var fixture: Book {
        Book(
            id: "XYZ123",
            volumeInfo: .fixture
        )
    }
}

extension VolumeInfo {
    static var fixture: VolumeInfo {
        VolumeInfo(
            title: "O Guia Definitivo de SwiftUI",
            authors: ["Maria da Silva", "João Souza"],
            publisher: "Editora App",
            publishedDate: "2025",
            description: "Este é um exemplo de uma descrição de livro um pouco mais longa para demonstrar como o texto se comporta...",
            pageCount: 320,
            categories: ["Mobile Development"],
            imageLinks: .fixture,
            industryIdentifiers: nil
        )
    }
}

extension ImageLinks {
    static var fixture: ImageLinks {
        ImageLinks(
            smallThumbnail: nil,
            thumbnail: "http://books.google.com/books/content?id=3e-dDAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
        )
    }
}

extension FavoriteBook {
    static var fixture: FavoriteBook {
        FavoriteBook(
            id: "XYZ123",
            title: "O Guia Definitivo de SwiftUI",
            coverURL: "https://books.google.com/books/content?id=3e-dDAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
            authors: ["Maria da Silva", "João Souza"],
            publisher: "Editora App",
            publishedDate: "2025",
            description: "Este é um exemplo de uma descrição de livro um pouco mais longa para demonstrar como o texto se comporta...",
            pageCount: 320,
            categories: ["Mobile Development"]
        )
    }
}

extension ReadingProgress {
    static var fixture: ReadingProgress {
        ReadingProgress(
            id: "XYZ123",
            title: "O Guia Definitivo de SwiftUI",
            coverURL: "https://books.google.com/books/content?id=3e-dDAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api",
            pageCount: 320)
    }
}

extension Annotation {
    static func fixture(with progress: ReadingProgress) -> Annotation {
        Annotation(
            content: "Essa parte do livro é muito interessante para revisar depois.",
            date: Date(timeIntervalSince1970: 0),
            page: nil,
            progress: progress
        )
    }
}
