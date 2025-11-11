//
//  BookView.swift
//  BooksApp
//
//  Created by 2213dtidigital on 17/06/25.
//
import SwiftUI
import SwiftData

struct BookDetails: View {
    // MARK: - Propriedades
    let selectedBook: Book
    @Query private var favoriteBooks: [FavoriteBook]
    @State private var forceRefresh = false
    @State private var progresses: [ReadingProgress] = []
    @State private var currentPage: String = ""
    @FocusState private var isTextFieldFocused: Bool
    @StateObject private var viewModel = FavoriteBookViewModel()
    @StateObject private var progressViewModel = ProgressViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                coverView
                titleView
                Divider()
                progressView
                Divider()
                metadataView
                Divider()
                authorsView
                Divider()
                descriptionView
                Spacer()
            }
            .padding()
        }
        .id(forceRefresh)
        .navigationTitle(selectedBook.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    Task {
                        await viewModel.toggleFavorite(selectedBook, in: favoriteBooks)
                    }
                } label: {
                    Image(systemName: viewModel.isFavorite(selectedBook, in: favoriteBooks) ? "heart.fill" : "heart")
                        .contentTransition(.symbolEffect(.replace))
                        .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
                .padding(8)
            }
        }
        .task {
            viewModel.setModelContext(modelContext)
            progressViewModel.setModelContext(modelContext)
            let results = await progressViewModel.fetchProgresses()
            progresses = results
        }
        .alert("alert.error.title", isPresented: $showAlert) {
            Button("button.done", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

// MARK: - Subviews
extension BookDetails {
    
    // MARK: Capa
    private var coverView: some View {
        VStack {
            BookCoverView(book: selectedBook)
                .frame(height: 180)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: Título
    private var titleView: some View {
        Text(selectedBook.title)
            .font(.largeTitle.bold())
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
    }
    
    // MARK: Metadados
    private var metadataView: some View {
        HStack(spacing: 20) {
            if let count = selectedBook.volumeInfo.pageCount {
                HStack {
                    Image(systemName: "book.pages")
                    Text("book.pages.count \(count)")
                }
            } else {
                Text("book.pages.not_available")
            }
            
            Divider()
            
            HStack {
                Image(systemName: "calendar")
                Text(selectedBook.volumeInfo.publishedDate
                     ?? String(localized: "book.published_date.not_available"))
            }
            
            Divider()
            
            if let categories = selectedBook.volumeInfo.categories?.first, !categories.isEmpty {
                HStack {
                    Image(systemName: "tag.fill")
                    Text(categories)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            } else {
                HStack {
                    Image(systemName: "tag.fill")
                    Text(String(localized: "book.categories.not_available"))
                }
            }
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: Autores
    private var authorsView: some View {
        HStack {
            Text("book.authors.label")
                .font(.title3.weight(.semibold))
            
            if let authors = selectedBook.volumeInfo.authors, !authors.isEmpty {
                Text(authors.joined(separator: ", "))
                    .font(.body)
                    .foregroundStyle(.secondary)
            } else {
                Text("book.authors.not_available")
                    .font(.subheadline)
                    .italic()
                    .foregroundStyle(.gray)
            }
        }
    }
    
    // MARK: Descrição
    private var descriptionView: some View {
        VStack(alignment: .leading) {
            Text(selectedBook.volumeInfo.description ?? String(localized: "book.description.not_available"))
                .font(.body)
        }
    }
    
    // MARK: Progresso
    private var progressView: some View {
        Group {
            if let existing = progresses.first(where: { $0.id == selectedBook.id }) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("progress.title")
                        .font(.title3.bold())
                    
                    if let total = existing.pageCount {
                        VStack(alignment: .leading, spacing: 8) {
                            ProgressView(value: min(1.0, Double(existing.currentPage) / Double(total)))
                                .progressViewStyle(.linear)
                                .tint(.blue)
                                .frame(height: 10)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                            Text("progress.page \(existing.currentPage) \(total)")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("progress.update_page.title")
                            .font(.subheadline.weight(.medium))
                        
                        HStack(spacing: 12) {
                            TextField("progress.current_page.placeholder", text: $currentPage)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                                .focused($isTextFieldFocused)
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        Spacer()
                                        Button("button.done") {
                                            if let total = existing.pageCount, let page = Int(currentPage) {
                                                if page <= total {
                                                    progressViewModel.updateProgress(existing, to: page)
                                                } else {
                                                    alertMessage = ErrorMessages.pageExceeds(total: total)
                                                    showAlert = true
                                                }
                                            } else if !currentPage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                                                      Int(currentPage) == nil {
                                                alertMessage = ErrorMessages.invalidPage
                                                showAlert = true
                                            }
                                            isTextFieldFocused = false
                                        }
                                    }
                                }
                            
                            Button(action: {
                                if let total = existing.pageCount, let page = Int(currentPage) {
                                    if page <= total {
                                        progressViewModel.updateProgress(existing, to: page)
                                    } else {
                                        alertMessage = ErrorMessages.pageExceeds(total: total)
                                        showAlert = true
                                    }
                                } else if !currentPage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                                          Int(currentPage) == nil {
                                    alertMessage = ErrorMessages.invalidPage
                                    showAlert = true
                                }
                            }) {
                                Label("button.save", systemImage: "checkmark.circle.fill")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("progress.notes.title")
                            .font(.subheadline.weight(.medium))
                        
                        NavigationLink(destination: AnnotationsView(progress: existing)) {
                            Label("progress.annotations.view", systemImage: "note.text")
                                .font(.body)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                VStack(spacing: 12) {
                    Text("progress.not_started.message")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        Task {
                            progressViewModel.startProgress(selectedBook)
                            let results = await progressViewModel.fetchProgresses()
                            progresses = results
                            currentPage = "0"
                        }
                    }) {
                        Label("progress.reading.start_button", systemImage: "book.fill")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}

// MARK: Preview
#Preview {
    NavigationStack {
        BookDetails(selectedBook: sampleBookForPreview)
    }
    .modelContainer(for: [FavoriteBook.self, ReadingProgress.self])
}
