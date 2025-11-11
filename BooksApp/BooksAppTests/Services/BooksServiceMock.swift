//
//  BooksServiceMock.swift
//  BooksAppTests
//
//  Created by 2213dtidigital on 04/07/25.
//

import Foundation
@testable import BooksApp

final class BooksServiceMock: BooksServicing {
    var forcedError: ServiceError?
    
    func getBooks(search: String) async throws -> [Book] {
        if let forcedError { throw forcedError }
        return [Book.fixture]
    }
}
