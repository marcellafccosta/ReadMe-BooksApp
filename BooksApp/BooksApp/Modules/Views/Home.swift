//
//  Home.swift
//  BooksApp
//
//  Created by 2213dtidigital on 16/06/25.
//

import SwiftUI
import SwiftData

struct Home: View {
    var body: some View {
        TabView {
            BookList()
                .tabItem{
                    Label("books.title", systemImage: "books.vertical.fill")
                }
            
            Favorites()
                .tabItem{
                    Label("favorites.title",
                          systemImage: "bookmark.fill")
                }
            
            ProgressList()
                .tabItem{
                    Label("progress.title",
                          systemImage: "progress.indicator")
                }
        }
    }
}

#Preview {
    Home()
        .modelContainer(for: FavoriteBook.self)
}
