//
//  AnnotationView.swift
//  BooksApp
//
//  Created by 2213dtidigital on 31/07/25.
//

import SwiftUI
import SwiftData

struct AnnotationsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var viewModel = AnnotationViewModel()
    var progress: ReadingProgress
    @FocusState private var isPageFieldFocused: Bool
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 16) {
            annotationInputSection
            
            if progress.annotations.isEmpty {
                Spacer()
                emptyStateView
                Spacer()
            } else {
                annotationsList
            }
        }
        .navigationTitle("annotation.add.title")
        .alert("alert.error.title", isPresented: $showAlert) {
            Button("button.done", role: .cancel) { }
        } message: { Text(alertMessage) }
    }
}

// MARK: - Subviews
extension AnnotationsView {
    private var annotationInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("annotation.add.title")
                .font(.headline)
            
            TextField("annotation.input.placeholder", text: $viewModel.newContent)
                .textFieldStyle(.roundedBorder)
            
            TextField("annotation.page.optional", text: $viewModel.newPage)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .focused($isPageFieldFocused)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("button.done") {
                            isPageFieldFocused = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
            
            Button {
                isPageFieldFocused = false
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
                if !viewModel.addAnnotation(to: progress, modelContext: modelContext) {
                    alertMessage = viewModel.lastErrorMessage ?? ""
                    showAlert = true
                }
            } label: {
                Label("button.add", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 12) {
            Image(systemName: "note.text")
                .font(.largeTitle)
                .foregroundStyle(.gray)
            Text("annotation.empty")
                .foregroundStyle(.gray)
                .font(.body)
        }
    }
    
    private var annotationsList: some View {
        List {
            ForEach(progress.annotations.sorted { $0.date > $1.date }, id: \.id) { annotation in
                VStack(alignment: .leading, spacing: 6) {
                    Text(annotation.content)
                        .font(.body)
                        .padding(.bottom, 2)
                    
                    if let page = annotation.page {
                        Text("annotation.page.label \(page)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(annotation.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption2)
                        .foregroundStyle(.gray)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .listRowSeparator(.hidden)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let annotation = progress.annotations.sorted { $0.date > $1.date }[index]
                    viewModel.delete(annotation, from: modelContext)
                }
            }
        }
        .listStyle(.plain)
    }
}
