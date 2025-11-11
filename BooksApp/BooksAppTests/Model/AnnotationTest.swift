//
//  AnnotationTest.swift
//  BooksAppTests
//
//  Created by 2213dtidigital on 04/08/25.
//

import XCTest
@testable import BooksApp

final class AnnotationTest: XCTestCase {
    
    private func makeSUT() -> Annotation {
        .fixture(with: .fixture)
    }
    
    func testCorrectValues() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.content, "Essa parte do livro é muito interessante para revisar depois.")
        XCTAssertEqual(sut.date, Date(timeIntervalSince1970: 0))
        XCTAssertEqual(sut.progress.id, "XYZ123")
        XCTAssertEqual(sut.progress.title, "O Guia Definitivo de SwiftUI")
        XCTAssertNil(sut.page)
    }
}
