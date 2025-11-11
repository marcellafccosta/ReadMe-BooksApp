//
//  FavoriteBookTest.swift
//  BooksAppTests
//
//  Created by 2213dtidigital on 04/07/25.
//

import XCTest
@testable import BooksApp

final class FavoriteBookTest: XCTestCase {
    private var favorite: FavoriteBook?
    
    override func setUpWithError() throws {
        favorite = .fixture
    }

    override func tearDownWithError() throws {
        favorite = nil
    }

    func testConversionToBook() throws {
        let favorite = try XCTUnwrap(favorite)
        let book = favorite.asBook()

        XCTAssertEqual(book.id, favorite.id)
        XCTAssertEqual(book.title, favorite.title)
        XCTAssertEqual(
            book.coverURL?.absoluteString,
            "https://books.google.com/books/content?id=3e-dDAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
        )
        XCTAssertEqual(book.volumeInfo.authors?.count, 2)
        XCTAssertEqual(book.volumeInfo.pageCount, 320)
    }
}
