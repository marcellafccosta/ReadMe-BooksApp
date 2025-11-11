//
//  ProgressViewModelTest.swift
//  BooksAppTests
//
//  Created by 2213dtidigital on 23/07/25.
//

import XCTest
@testable import BooksApp
import SwiftData

@MainActor
final class ProgressViewModelTest: XCTestCase {
    func testStartProgress() throws {
        let (sut, context) = try makeSUT()
        sut.startProgress(.fixture)
        
        let allProgress = try context.fetch(FetchDescriptor<ReadingProgress>())
        
        XCTAssertEqual(allProgress.count, 1)
        XCTAssertEqual(allProgress.first?.title, "O Guia Definitivo de SwiftUI")
    }
    
    func testUpdateProgress() throws {
        let (sut, context) = try makeSUT()
        sut.startProgress(.fixture)
        
        let progress = try context.fetch(FetchDescriptor<ReadingProgress>()).first!
        sut.updateProgress(progress, to: 100)
        
        let updated = try context.fetch(FetchDescriptor<ReadingProgress>()).first!
        XCTAssertEqual(updated.currentPage, 100)
    }
    
    func testDeleteProgress() throws {
        let (sut, context) = try makeSUT()
        sut.startProgress(.fixture)
        
        let progress = try context.fetch(FetchDescriptor<ReadingProgress>()).first!
        sut.deleteProgress(progress)
        
        let remaining = try context.fetch(FetchDescriptor<ReadingProgress>())
        XCTAssertTrue(remaining.isEmpty)
    }
}

private extension ProgressViewModelTest {
    func makeSUT() throws -> (ProgressViewModel, ModelContext) {
        let container = try ModelContainer(for: ReadingProgress.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = ModelContext(container)
        let viewModel = ProgressViewModel()
        viewModel.setModelContext(context)
        
        return (viewModel, context)
    }
}
