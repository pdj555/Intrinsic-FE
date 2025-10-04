import SwiftUI

struct SettingsView: View {
    @AppStorage("apiBaseURL") private var apiBaseURL = "http://localhost:8000"
    @State private var tempURL: String = ""
    @State private var showingSaved = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("API Configuration")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Base URL")
                            .font(.headline)
                        
                        TextField("http://localhost:8000", text: $tempURL)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.URL)
                        
                        Button(action: saveURL) {
                            Text("Save")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        if showingSaved {
                            Label("Saved!", systemImage: "checkmark.circle.fill")
                                .foregroundColor(.green)
                                .font(.subheadline)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("About")) {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Buffett Stock Analyzer")
                            .font(.headline)
                        Text("Analyze stocks using value investing principles inspired by Warren Buffett's methodology.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("How to Use")) {
                    VStack(alignment: .leading, spacing: 12) {
                        InstructionRow(
                            icon: "magnifyingglass",
                            title: "Search",
                            description: "Enter any stock ticker to get a detailed analysis"
                        )
                        
                        InstructionRow(
                            icon: "chart.bar.fill",
                            title: "Top Picks",
                            description: "Browse S&P 500 stocks ranked by value opportunity"
                        )
                        
                        InstructionRow(
                            icon: "checkmark.shield.fill",
                            title: "Quality Score",
                            description: "7 quality checks based on financial health"
                        )
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            tempURL = apiBaseURL
        }
    }
    
    private func saveURL() {
        var urlToSave = tempURL.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove trailing slash if present
        if urlToSave.hasSuffix("/") {
            urlToSave = String(urlToSave.dropLast())
        }
        
        apiBaseURL = urlToSave
        APIService.shared.baseURL = urlToSave
        
        showingSaved = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showingSaved = false
        }
    }
}

// MARK: - Instruction Row
struct InstructionRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SettingsView()
}

