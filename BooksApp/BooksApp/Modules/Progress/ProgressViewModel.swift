//
//  ProgressViewModel.swift
//  BooksApp
//
//  Created by 2213dtidigital on 21/07/25.
//

import Foundation
import SwiftData

@MainActor
class ProgressViewModel: ObservableObject {
    private var modelContext: ModelContext?
    @Published var progresses: [ReadingProgress] = []
    
    init() {}
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    // MARK: - Ações principais
    
    func startProgress(_ book: Book) {
        guard let modelContext = modelContext else { return }
        
        do {
            let existing = try? modelContext.fetch(FetchDescriptor<ReadingProgress>(
                predicate: #Predicate { $0.id == book.id }
            ))
            print("Progresso encontrado:", existing ?? [])
            
            if let existing = existing, existing.isEmpty {
                let progress = ReadingProgress(
                    id: book.id,
                    title: book.title,
                    coverURL: book.coverURL?.absoluteString,
                    currentPage: 0,
                    pageCount: book.volumeInfo.pageCount
                )
                modelContext.insert(progress)
                try modelContext.save()
                print("Progresso criado")
            } else {
                print("Já existe progresso")
            }
        } catch {
            print("Erro ao iniciar progresso: \(error)")
        }
    }
    
    
    func updateProgress(_ progress: ReadingProgress, to page: Int) {
        progress.currentPage = page
        progress.lastUpdated = Date()
        
        do {
            try modelContext?.save()
        } catch {
            print("Erro ao atualizar progresso: \(error)")
        }
    }
    
    func deleteProgress(_ progress: ReadingProgress) {
        guard let modelContext = modelContext else { return }
        
        modelContext.delete(progress)
        
        do {
            try modelContext.save()
        } catch {
            print("Erro ao deletar progresso: \(error)")
        }
    }
    
    func fetchProgresses() async -> [ReadingProgress] {
        guard let modelContext = modelContext else { return [] }
        
        do {
            let results = try modelContext.fetch(FetchDescriptor<ReadingProgress>())
            print("Progressos buscados:", results.map { $0.title })
            return results
        } catch {
            print("Erro ao buscar progressos: \(error)")
            return []
        }
    }

}
