import SwiftUI

struct ContentView: View {
    @AppStorage("apiBaseURL") private var apiBaseURL = "http://localhost:8000"
    
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            
            OpportunitiesView()
                .tabItem {
                    Label("Top Picks", systemImage: "chart.bar.fill")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .onAppear {
            // Initialize API service with stored URL
            APIService.shared.baseURL = apiBaseURL
        }
    }
}

#Preview {
    ContentView()
}

