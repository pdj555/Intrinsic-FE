import SwiftUI

struct OpportunitiesView: View {
    @State private var opportunities: [OpportunityItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var selectedTicker: String?
    @State private var showingDetail = false
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading && opportunities.isEmpty {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading top opportunities...")
                            .foregroundColor(.secondary)
                    }
                } else if let error = errorMessage, opportunities.isEmpty {
                    ErrorView(message: error) {
                        loadOpportunities()
                    }
                    .padding()
                } else if opportunities.isEmpty {
                    EmptyOpportunitiesView()
                } else {
                    List(opportunities) { item in
                        OpportunityRow(item: item)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedTicker = item.ticker
                                showingDetail = true
                            }
                    }
                    .refreshable {
                        await refresh()
                    }
                }
            }
            .navigationTitle("Top Picks")
            .sheet(isPresented: $showingDetail) {
                if let ticker = selectedTicker {
                    StockDetailSheet(ticker: ticker)
                }
            }
        }
        .onAppear {
            if opportunities.isEmpty {
                loadOpportunities()
            }
        }
    }
    
    private func loadOpportunities() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let items = try await APIService.shared.getTopOpportunities()
                await MainActor.run {
                    opportunities = items
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
    
    private func refresh() async {
        do {
            let items = try await APIService.shared.getTopOpportunities()
            await MainActor.run {
                opportunities = items
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
        }
    }
}

// MARK: - Opportunity Row
struct OpportunityRow: View {
    let item: OpportunityItem
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.ticker)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(item.companyName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(item.formattedMOS)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                
                RecommendationBadge(recommendation: item.recommendation)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Empty Opportunities View
struct EmptyOpportunitiesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text("No opportunities available")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text("Pull to refresh")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Stock Detail Sheet
struct StockDetailSheet: View {
    let ticker: String
    @Environment(\.dismiss) var dismiss
    @State private var analysis: StockAnalysis?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    if isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding(.top, 60)
                    } else if let error = errorMessage {
                        ErrorView(message: error) {
                            loadAnalysis()
                        }
                        .padding()
                    } else if let analysis = analysis {
                        StockDetailCard(analysis: analysis)
                            .padding()
                    }
                }
            }
            .navigationTitle(ticker)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadAnalysis()
        }
    }
    
    private func loadAnalysis() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let result = try await APIService.shared.analyzeStock(ticker: ticker)
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

#Preview {
    OpportunitiesView()
}

