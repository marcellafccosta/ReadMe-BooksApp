//
//  FavoriteBookViewModel.swift
//  BooksApp
//
//  Created by 2213dtidigital on 23/06/25.
//

import Foundation
import SwiftData

@MainActor
class FavoriteBookViewModel: ObservableObject {
    private var modelContext: ModelContext?
    
    // MARK: - Init
    init() {}
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // MARK: - Ações principais
    
    func addToFavorites(_ book: Book) async {
        guard let modelContext else { return }
        
        let descriptor = FetchDescriptor<FavoriteBook>(
            predicate: #Predicate { $0.id == book.id }
        )
        
        do {
            let existing = try modelContext.fetch(descriptor)
            if existing.isEmpty {
                let favoriteBook = FavoriteBook(
                    id: book.id,
                    title: book.title,
                    coverURL: book.coverURL?.absoluteString,
                    authors: book.volumeInfo.authors,
                    publisher: book.volumeInfo.publisher,
                    publishedDate: book.volumeInfo.publishedDate,
                    description: book.volumeInfo.description,
                    pageCount: book.volumeInfo.pageCount,
                    categories: book.volumeInfo.categories
                )
                modelContext.insert(favoriteBook)
                try modelContext.save()
            }
        } catch {
            print("Erro ao adicionar favorito: \(error)")
        }
    }
    
    func removeFromFavorites(_ favorite: FavoriteBook) async {
        guard let modelContext else { return }
        
        modelContext.delete(favorite)
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao remover favorito: \(error)")
        }
    }
    
    func toggleFavorite(_ book: Book, in favorites: [FavoriteBook]) async {
        if let existing = favorites.first(where: { $0.id == book.id }) {
            await removeFromFavorites(existing)
        } else {
            await addToFavorites(book)
        }
    }
    
    func clearAllFavorites(_ favorites: [FavoriteBook]) {
        guard let modelContext else { return }
        
        for favorite in favorites {
            modelContext.delete(favorite)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao limpar favoritos: \(error)")
        }
    }
    
    // MARK: - Utilitários
    
    func isFavorite(_ book: Book, in favorites: [FavoriteBook]) -> Bool {
        favorites.contains { $0.id == book.id }
    }
    
    func formattedDate(_ date: Date) -> String {
        date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func favoritesCountText(_ count: Int) -> String {
        String(format: NSLocalizedString("favorites.title.count", comment: ""), count)
    }
}
