//
//  ViewModel.swift
//  BooksApp
//
//  Created by 2213dtidigital on 16/06/25.
//

import Foundation

class BookViewModel: ObservableObject {
    @Published var books: [Book] = [] {
        didSet {
            filteredBooks = books
        }
    }
    @Published var filteredBooks: [Book] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    let service: BooksServicing
    
    private let key = "AIzaSyBaRkP3ahUC0IOoLjTbmS4VHILwBPU3ySQ"
    
    init(service: BooksServicing) {
        self.service = service
    }
    
    @MainActor
    func fetchBooks(searchQuery: String, isSearchAction: Bool) async {
        guard books.isEmpty || isSearchAction else {
            return
        }
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let apiResponse = try await service.getBooks(search: searchQuery)
            if isSearchAction {
                self.filteredBooks = apiResponse
            } else {
                self.books = apiResponse
            }
            
        } catch {
            self.errorMessage = "Falha ao buscar os livros. Tente novamente."
            print(error.localizedDescription)
            print("Erro na busca ou decodificação: \(error)")
        }
        self.isLoading = false
    }
    
    func clearSearch() {
        filteredBooks = books
    }
}
