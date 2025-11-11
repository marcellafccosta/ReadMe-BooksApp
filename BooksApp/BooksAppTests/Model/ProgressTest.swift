//
//  ProgressTest.swift
//  BooksAppTests
//
//  Created by 2213dtidigital on 23/07/25.
//

import XCTest
@testable import BooksApp

final class ProgressTest: XCTestCase {
    private func makeSUT() -> ReadingProgress {
        .fixture
    }
    
    func testCorrectValues() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.id, "XYZ123")
        XCTAssertEqual(sut.title, "O Guia Definitivo de SwiftUI")
        XCTAssertEqual(sut.currentPage, 0)
        XCTAssertEqual(sut.pageCount, 320)
        XCTAssertNotNil(sut.lastUpdated)
    }
}
