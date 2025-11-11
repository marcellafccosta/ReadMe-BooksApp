//
//  BookViewModel.swift
//  BooksAppTests
//
//  Created by 2213dtidigital on 04/07/25.
//

import XCTest
@testable import BooksApp

final class BookViewModelTest: XCTestCase {
    func testfetchBooksSuccess() async throws {
        let sut = makeSUT()
        
        await sut.fetchBooks(searchQuery: "SwiftUI", isSearchAction: false)
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.books.count, 1)
        XCTAssertEqual(sut.filteredBooks.count, 1)
        XCTAssertEqual(sut.books.first?.title, "O Guia Definitivo de SwiftUI")
    }
    
    func testFetchBooksFailure() async throws {
        let errorMock = BooksServiceMock()
        errorMock.forcedError = .unknownError
        let sut = makeSUT(service: errorMock)
        await sut.fetchBooks(searchQuery: "SwiftUI", isSearchAction: false)
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertEqual(sut.books.count, 0)
    }
    
    func testClearSearch() async throws {
        let sut = makeSUT()
        sut.books = [.fixture]
        sut.filteredBooks = []
        
        sut.clearSearch()
        
        XCTAssertEqual(sut.filteredBooks.count, sut.books.count)
        XCTAssertEqual(sut.filteredBooks.first?.title, sut.books.first?.title)
    }
}

private extension BookViewModelTest {
    func makeSUT(service: BooksServicing? = nil) -> BookViewModel {
        let mockService = service ?? BooksServiceMock()
        return BookViewModel(service: mockService)
    }
}
