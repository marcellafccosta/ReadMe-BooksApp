//
//  Progress.swift
//  BooksApp
//
//  Created by 2213dtidigital on 21/07/25.
//

import SwiftUI
import SwiftData

struct ProgressList: View {
    
    // MARK: - Properties
    @Query(sort: \ReadingProgress.title, order: .forward)
    private var progresses: [ReadingProgress]
    @StateObject private var progressViewModel = ProgressViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var currentPages: [String: String] = [:]
    @FocusState private var focusedFieldId: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("progress.title")
                .onAppear { progressViewModel.setModelContext(modelContext) }
                .alert("alert.error.title", isPresented: $showAlert) {
                    Button("button.done", role: .cancel) { }
                } message: { Text(alertMessage) }
        }
        .toolbar { navigationToolbar }
        
        .safeAreaInset(edge: .bottom) {
            if focusedFieldId != nil {
                HStack {
                    Spacer()
                    Button("button.done") { focusedFieldId = nil }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.ultraThinMaterial)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut(duration: 0.2), value: focusedFieldId != nil)
            }
        }
    }
    
    // MARK: - Content
    @ViewBuilder
    private var content: some View {
        if progresses.isEmpty {
            emptyState
        } else {
            List {
                ForEach(progresses, id: \.id) { progress in
                    progressRow(for: progress)
                }
                .onDelete(perform: deleteProgress)
            }
            .listStyle(.insetGrouped)
        }
    }
    
    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var navigationToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton()
        }
    }
    
    // MARK: - Actions
    private func saveProgress(progressId: String) {
        guard let progress = progresses.first(where: { $0.id == progressId }),
              let text = currentPages[progressId] else { return }
        
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let newPage = Int(trimmed) else {
            if !trimmed.isEmpty {
                alertMessage = ErrorMessages.invalidPage
                showAlert = true
            }
            return
        }
        
        if let total = progress.pageCount, newPage > total {
            alertMessage = ErrorMessages.pageExceeds(total: total)
            showAlert = true
            return
        }
        
        progressViewModel.updateProgress(progress, to: newPage)
    }
    
    private func deleteProgress(at offsets: IndexSet) {
        for index in offsets {
            progressViewModel.deleteProgress(progresses[index])
        }
    }
}

// MARK: - Subviews
extension ProgressList {
    
    @ViewBuilder
    private func progressRow(for progress: ReadingProgress) -> some View {
        let progressId = progress.id
        let binding = Binding<String>(
            get: { currentPages[progressId] ?? "\(progress.currentPage)" },
            set: { newValue in currentPages[progressId] = newValue }
        )
        
        HStack(alignment: .top, spacing: 16) {
            BookCoverView(book: progress.asBook())
                .frame(width: 60, height: 90)
            
            VStack(alignment: .leading, spacing: 10) {
                Text(progress.title)
                    .font(.headline)
                    .lineLimit(2)
                    .padding(.bottom, 4)
                
                if let total = progress.pageCount {
                    progressSection(progress: progress, total: total)
                }
                
                inputSection(progressId: progressId, binding: binding)
                
                NavigationLink(destination: AnnotationsView(progress: progress)) {
                    Label("progress.annotations.view", systemImage: "note.text")
                        .font(.subheadline)
                }
                .buttonStyle(.bordered)
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 12)
        .onAppear {
            if currentPages[progressId] == nil {
                currentPages[progressId] = "\(progress.currentPage)"
            }
        }
    }
    
    @ViewBuilder
    private func progressSection(progress: ReadingProgress, total: Int) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ProgressView(value: Double(progress.currentPage) / Double(total))
                .progressViewStyle(.linear)
                .tint(.blue)
                .frame(height: 8)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            Text("progress.page \(progress.currentPage) \(total)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private func inputSection(progressId: String, binding: Binding<String>) -> some View {
        HStack(spacing: 12) {
            TextField("progress.current_page.placeholder", text: binding)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 100)
                .focused($focusedFieldId, equals: progressId)
            
            Button {
                saveProgress(progressId: progressId)
                focusedFieldId = nil
            } label: {
                Label("button.save", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.white)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "book")
                .font(.system(size: 40))
                .foregroundStyle(.gray)
            Text("progress.empty.title")
                .font(.headline)
                .foregroundStyle(.gray)
            Text("progress.empty.subtitle")
                .font(.subheadline)
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 80)
    }
}
