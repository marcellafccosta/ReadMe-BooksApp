//
//  NetworkService.swift
//  BooksApp
//
//  Created by 2213dtidigital on 18/06/25.
//

import Foundation

protocol NetworkService {
    func fetch<T: Codable>(path: String, queryItems: [URLQueryItem]) async throws -> T
}

extension NetworkService {
    func fetch<T: Codable>(path: String, queryItems: [URLQueryItem]) async throws -> T {
        let baseURL = "https://www.googleapis.com/"
        guard let url = URL(string: baseURL)?.appendingPathComponent(path) else {
            throw ServiceError.invalidURL
        }
        let request = URLRequest(url: url.appending(queryItems: queryItems))
        
        do {
           let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw ServiceError.unknownError
            }
            switch response.statusCode {
            case 200...299:
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    return decodedResponse
                } catch {
                    throw ServiceError.wrongDecoding
                }
            case 404:
                throw ServiceError.notFound
            default:
                throw ServiceError.unknownError
            }
        } catch {
            throw ServiceError.unknownError
        }
    }
}

enum ServiceError: Error {
    case invalidURL
    case unknownError
    case notFound
    case wrongDecoding
}
