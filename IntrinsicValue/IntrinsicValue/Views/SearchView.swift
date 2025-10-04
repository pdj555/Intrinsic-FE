import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var analysis: StockAnalysis?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Search Bar
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            
                            TextField("Enter ticker (e.g., AAPL)", text: $searchText)
                                .textFieldStyle(.plain)
                                .autocapitalization(.allCharacters)
                                .disableAutocorrection(true)
                                .focused($isSearchFocused)
                                .onSubmit {
                                    performSearch()
                                }
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                    analysis = nil
                                    errorMessage = nil
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        
                        Button(action: performSearch) {
                            Text("Search")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(searchText.isEmpty ? Color.gray : Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        .disabled(searchText.isEmpty || isLoading)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Content Area
                    if isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Analyzing \(searchText.uppercased())...")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else if let error = errorMessage {
                        ErrorView(message: error) {
                            performSearch()
                        }
                        .padding(.horizontal)
                    } else if let analysis = analysis {
                        StockDetailCard(analysis: analysis)
                            .padding(.horizontal)
                    } else {
                        EmptyStateView()
                            .padding(.top, 60)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Stock Analyzer")
        }
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        
        isSearchFocused = false
        isLoading = true
        errorMessage = nil
        analysis = nil
        
        Task {
            do {
                let result = try await APIService.shared.analyzeStock(ticker: searchText)
                await MainActor.run {
                    analysis = result
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("Search for a stock to analyze")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text("Enter any S&P 500 ticker symbol above")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: onRetry) {
                Text("Retry")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    SearchView()
}

