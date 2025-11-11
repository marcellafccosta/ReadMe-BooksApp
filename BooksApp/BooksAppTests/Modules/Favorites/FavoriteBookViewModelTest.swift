//
//  FavoriteBookViewModelTest.swift
//  BooksAppTests
//
//  Created by 2213dtidigital on 04/07/25.
//

import XCTest
import SwiftData
@testable import BooksApp

@MainActor
final class FavoriteBookViewModelTest: XCTestCase {
    func testAddToFavorites() async throws {
        let (sut, context) = try makeSUT()
        await sut.addToFavorites(.fixture)
        
        let items = try context.fetch(FetchDescriptor<FavoriteBook>())
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.title, "O Guia Definitivo de SwiftUI")
    }
    
    func testRemoveFromFavorites() async throws {
        let (sut, context) = try makeSUT()
        
        let favorite = FavoriteBook.fixture
        context.insert(favorite)
        try context.save()
        
        await sut.removeFromFavorites(favorite)
        
        let items = try context.fetch(FetchDescriptor<FavoriteBook>())
        XCTAssertEqual(items.count, 0)
    }
    
    func testToggleFavorite_addsIfNotExists() async throws {
        let (sut, context) = try makeSUT()
        await sut.toggleFavorite(.fixture, in: [])
        
        let items = try context.fetch(FetchDescriptor<FavoriteBook>())
        XCTAssertEqual(items.count, 1)
    }
    
    func testToggleFavorite_removesIfExists() async throws {
        let (sut, context) = try makeSUT()
        
        let favorite = FavoriteBook.fixture
        context.insert(favorite)
        try context.save()
        
       await sut.toggleFavorite(favorite.asBook(), in: [favorite])
        
        let items = try context.fetch(FetchDescriptor<FavoriteBook>())
        XCTAssertEqual(items.count, 0)
    }
    
    func testIsFavorite_returnsTrueIfExists() throws {
        let (sut, _) = try makeSUT()
        let favorite = FavoriteBook.fixture
        let result = sut.isFavorite(favorite.asBook(), in: [favorite])
        XCTAssertTrue(result)
    }
}

private extension FavoriteBookViewModelTest {
    func makeSUT() throws -> (FavoriteBookViewModel, ModelContext) {
        let container = try ModelContainer(
            for: FavoriteBook.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = ModelContext(container)
        let viewModel = FavoriteBookViewModel()
        viewModel.setModelContext(context)
        
        return (viewModel, context)
    }
}
