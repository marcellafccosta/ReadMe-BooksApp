//
//  BooksService.swift
//  BooksApp
//
//  Created by 2213dtidigital on 18/06/25.
//

import Foundation

protocol BooksServicing {
    func getBooks(search: String) async throws -> [Book]
}

class BooksService: NetworkService, BooksServicing {
    func getBooks(search: String) async throws -> [Book] {
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "q", value: search.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)), URLQueryItem(name: "key", value: ""), URLQueryItem(name: "maxResults", value: "30"),]
        let response: Paging = try await fetch(path: "books/v1/volumes", queryItems: queryItems)
        return response.items
    }
}
