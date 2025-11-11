//
//  Favorites.swift
//  BooksApp
//
//  Created by 2213dtidigital on 17/06/25.
//

import SwiftUI
import SwiftData

struct Favorites: View {
    
    // MARK: - Properties
    @Query(sort: \FavoriteBook.dateAdded, order: .reverse)
    private var favoriteBooks: [FavoriteBook]
    @StateObject private var viewModel = FavoriteBookViewModel()
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                if favoriteBooks.isEmpty {
                    emptyStateView
                } else {
                    ForEach(favoriteBooks, id: \.id) { favorite in
                        favoriteBookRow(book: favorite)
                    }
                    .onDelete(perform: deleteFavorites)
                }
            }
            .navigationTitle(viewModel.favoritesCountText(favoriteBooks.count))
            .toolbar {
                EditButton()
            }
        }
        .onAppear {
            viewModel.setModelContext(modelContext)
        }
    }
}

extension Favorites {
    
    // MARK: - Delete Favorites
    private func deleteFavorites(_ offsets: IndexSet) {
        Task {
            for index in offsets {
                let book = favoriteBooks[index]
                await viewModel.removeFromFavorites(book)
            }
        }
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 50))
                .foregroundStyle(.gray)
            
            Text("favorites.empty.message")
                .font(.headline)
                .foregroundStyle(.gray)
            
            Text("favorites.instruction")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 80)
    }
    
    // MARK: - Favorite Book Row
    private func favoriteBookRow(book: FavoriteBook) -> some View {
        NavigationLink(destination: BookDetails(selectedBook: book.asBook())) {
            HStack(spacing: 16) {
                BookCoverView(book: book.asBook())
                    .frame(width: 60, height: 90)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(book.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text("added_on \(viewModel.formattedDate(book.dateAdded))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 6)
        }
    }
}

// MARK: - Preview
#Preview {
    Favorites()
        .modelContainer(for: FavoriteBook.self)
}
