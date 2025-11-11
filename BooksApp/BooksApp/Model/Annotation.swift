//
//  Annotation.swift
//  BooksApp
//
//  Created by 2213dtidigital on 31/07/25.
//

import Foundation
import SwiftData

@Model
class Annotation {
    var id: UUID
    var content: String
    var date: Date
    var page: Int?
    @Relationship var progress: ReadingProgress
    
    init(content: String, date: Date = .now, page: Int? = nil, progress: ReadingProgress) {
        self.id = UUID()
        self.content = content
        self.date = date
        self.page = page
        self.progress = progress
    }
}
