//
//  Book.swift
//  BooksAppTests
//
//  Created by 2213dtidigital on 04/07/25.
//

import XCTest
@testable import BooksApp

final class BookTests: XCTestCase {

    private func makeBookSUT() -> Book {
        .fixture
    }

    func testBookTitle() throws {
        let book = makeBookSUT()
        XCTAssertEqual(book.title, "O Guia Definitivo de SwiftUI")
    }

    func testPagingReturnsCorrectNumberOfItems() throws {
        let paging = makePagingSUT()
        XCTAssertEqual(paging.totalItems, 5)
        XCTAssertEqual(paging.items.count, 5)
    }
}

private extension BookTests {
    func makePagingSUT(count: Int = 5) -> Paging {
        Paging.fixture(totalItems: count, items: Array(repeating: .fixture, count: count))
    }
}
