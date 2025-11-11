//
//  BookCoverView.swift
//  BooksApp
//
//  Created by 2213dtidigital on 18/06/25.
//

import SwiftUI

struct BookCoverView: View {
    let book: Book
    var body: some View {
        VStack {
            AsyncImage(url: book.coverURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .shadow(radius: 5)
            } placeholder: {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.3))
                        .cornerRadius(8)
                    ProgressView()
                }
            }
            .frame(height: 180)
        }
    }
}

#Preview {
    BookCoverView(book: sampleBookForPreview)
}

let sampleBookForPreview = Book(
    id: "XYZ123",
    volumeInfo: VolumeInfo(
        title: "O Guia Definitivo de SwiftUI",
        authors: ["Maria da Silva", "João Souza"],
        publisher: "Editora App",
        publishedDate: "2025",
        description: "Este é um exemplo de uma descrição de livro um pouco mais longa para demonstrar como o texto se comporta...",
        pageCount: 320,
        categories: ["Mobile Development"],
        imageLinks: ImageLinks(smallThumbnail: nil, thumbnail: "http://books.google.com/books/content?id=3e-dDAAAQBAJ&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"),
        industryIdentifiers: nil
    ))
