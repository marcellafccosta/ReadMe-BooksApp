//
//  AnnotationViewModel.swift
//  BooksApp
//
//  Created by 2213dtidigital on 31/07/25.
//

import Foundation
import SwiftData

@MainActor
class AnnotationViewModel: ObservableObject {
    @Published var newContent: String = ""
    @Published var newPage: String = ""
    @Published var lastErrorMessage: String? = nil
    
    func addAnnotation(to progress: ReadingProgress, modelContext: ModelContext) -> Bool {
        let content = newContent.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !content.isEmpty else {
            lastErrorMessage = ErrorMessages.emptyContent
            return false
        }
        
        var page: Int? = nil
        let pageText = newPage.trimmingCharacters(in: .whitespacesAndNewlines)
        if !pageText.isEmpty {
            guard let p = Int(pageText) else {
                lastErrorMessage = ErrorMessages.invalidPage
                return false
            }
            if let total = progress.pageCount, p > total {
                lastErrorMessage = ErrorMessages.pageExceeds(total: total)
                return false
            }
            page = p
        }
        
        let annotation = Annotation(content: content, page: page, progress: progress)
        modelContext.insert(annotation)

        try? modelContext.save()
        
        newContent = ""
        newPage = ""
        return true
    }
    
    func delete(_ annotation: Annotation, from context: ModelContext) {
        context.delete(annotation)
    }
}
