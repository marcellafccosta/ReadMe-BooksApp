//
//  ErrorMessages.swift
//  BooksApp
//
//  Created by 2213dtidigital on 14/08/25.
//

enum ErrorMessages {
    static let emptyContent = String(localized: "errors.empty_content")
    static let invalidPage  = String(localized: "errors.invalid_page")

    static func pageExceeds(total: Int) -> String {
        let format = String(localized: "errors.page_exceeds")
        return String.localizedStringWithFormat(format, total)
    }
}
