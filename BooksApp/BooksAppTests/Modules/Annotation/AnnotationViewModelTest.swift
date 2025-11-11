//
//  AnnotationViewModelTest.swift
//  BooksAppTests
//
//  Created by 2213dtidigital on 04/08/25.
//

import XCTest
@testable import BooksApp
import SwiftData

@MainActor
final class AnnotationViewModelTest: XCTestCase {
    
    func testAddAnnotation() throws {
        let (sut, context, progress) = try makeSUT()
        
        let expected = Annotation.fixture(with: progress)
        
        sut.newContent = expected.content
        if let page = expected.page {
            sut.newPage = String(page)
        } else {
            sut.newPage = ""
        }
        
        sut.addAnnotation(to: progress, modelContext: context)
        
        let results = try context.fetch(FetchDescriptor<Annotation>())
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.content, expected.content)
        XCTAssertEqual(results.first?.page, expected.page)
        XCTAssertEqual(results.first?.progress.id, expected.progress.id)
    }
    
    func testAddAnnotationWithoutPage() throws {
          let (sut, context, progress) = try makeSUT()
          
          sut.newContent = "Anotação sem número de página"
          sut.newPage = ""
        
          sut.addAnnotation(to: progress, modelContext: context)
          
          let results = try context.fetch(FetchDescriptor<Annotation>())
          
          XCTAssertEqual(results.count, 1)
          XCTAssertEqual(results.first?.content, "Anotação sem número de página")
          XCTAssertNil(results.first?.page)
          XCTAssertEqual(results.first?.progress.id, progress.id)
      }

    func testDeleteAnnotation() throws {
           let (sut, context, progress) = try makeSUT()
           
           let annotation = Annotation.fixture(with: progress)
           context.insert(progress)
           context.insert(annotation)
           try context.save()
           
           var results = try context.fetch(FetchDescriptor<Annotation>())
           XCTAssertEqual(results.count, 1)
           
           sut.delete(annotation, from: context)
           
           results = try context.fetch(FetchDescriptor<Annotation>())
           XCTAssertTrue(results.isEmpty)
       }
   }

private extension AnnotationViewModelTest {
    func makeSUT() throws -> (AnnotationViewModel, ModelContext, ReadingProgress) {
        let container = try ModelContainer(for: Annotation.self, ReadingProgress.self,
                                           configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        let context = ModelContext(container)
        let viewModel = AnnotationViewModel()
        let progress = ReadingProgress.fixture
        context.insert(progress)
        try context.save()
        
        return (viewModel, context, progress)
    }
}
