//
//  BooksAppApp.swift
//  BooksApp
//
//  Created by 2213dtidigital on 16/06/25.
//

import SwiftUI
import SwiftData

@main
struct BooksAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [FavoriteBook.self, ReadingProgress.self])
    }
}
