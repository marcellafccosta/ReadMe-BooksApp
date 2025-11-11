//
//  Books.swift
//  BooksApp
//
//  Created by 2213dtidigital on 16/06/25.
//

import SwiftUI
import SwiftData

struct BookList: View {
    
    // MARK: - Propriedades
    @StateObject private var viewModel = BookViewModel(service: BooksService())
    @StateObject private var favoritesViewModel = FavoriteBookViewModel()
    @State private var searchBook = ""
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]
    private let initialSearchTerm = "SwiftUI"
    @Query private var favoriteBooks: [FavoriteBook]
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                bookGridView
                overlayView
            }
            .navigationTitle("booklist.title")
            .searchable(text: $searchBook)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.fetchBooks(searchQuery: searchBook, isSearchAction: true)
                }
            }
            .onChange(of: searchBook) {
                if searchBook.isEmpty {
                    viewModel.clearSearch()
                }
            }
            .task {
                await viewModel.fetchBooks(searchQuery: initialSearchTerm, isSearchAction: false)
            }
            .onAppear {
                favoritesViewModel.setModelContext(modelContext)
            }
        }
    }
}

// MARK: - Subviews
extension BookList {
    
    // MARK: Overlay
    @ViewBuilder
    private var overlayView: some View {
        if viewModel.isLoading {
            ProgressView("search.loading")
                .scaleEffect(1.5)
                .tint(.blue)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.regularMaterial)
        } else if let errorMessage = viewModel.errorMessage {
            VStack(spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.red)
                Text(errorMessage)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Button("button.done") {
                    Task {
                        await viewModel.fetchBooks(
                            searchQuery: searchBook.isEmpty ? initialSearchTerm : searchBook,
                            isSearchAction: !searchBook.isEmpty
                        )
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
        } else if viewModel.filteredBooks.isEmpty {
            ContentUnavailableView(
                "books.none",
                systemImage: "book.closed",
                description: Text("booklist.empty.description")
            )
        }
    }
    
    // MARK: Grid de Livros
    @ViewBuilder
    private var bookGridView: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 20) {
                ForEach(viewModel.filteredBooks) { book in
                    NavigationLink(destination: BookDetails(selectedBook: book)) {
                        VStack {
                            ZStack(alignment: .topTrailing) {
                                BookCoverView(book: book)
                                
                                Button(action: {
                                    Task {
                                        await favoritesViewModel.toggleFavorite(book, in: favoriteBooks)
                                    }
                                }) {
                                    let isFav = favoritesViewModel.isFavorite(book, in: favoriteBooks)
                                    
                                    Image(systemName: isFav ? "heart.fill" : "heart")
                                        .contentTransition(.symbolEffect(.replace))
                                        .foregroundStyle(isFav ? .red : .white)
                                        .font(.title2)
                                        .shadow(color: .black, radius: 2)
                                        .padding(6)
                                }
                                .buttonStyle(.plain)
                                .padding(8)
                            }
                            
                            Text(book.title)
                                .font(.headline)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .frame(height: 50, alignment: .top)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Preview
#Preview {
    BookList()
        .modelContainer(for: FavoriteBook.self)
}
