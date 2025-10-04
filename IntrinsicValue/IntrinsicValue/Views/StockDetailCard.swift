import SwiftUI

struct StockDetailCard: View {
    let analysis: StockAnalysis
    @State private var showDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Company Name
            Text(analysis.companyName)
                .font(.title2)
                .fontWeight(.bold)
            
            // Summary
            Text(analysis.summary)
                .font(.title3)
                .foregroundColor(.primary)
                .padding(.vertical, 8)
            
            // Price vs Intrinsic Value
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Current Price")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(analysis.formattedPrice)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading) {
                    Text("Intrinsic Value")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(analysis.formattedIntrinsicValue)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
            }
            .padding(.vertical, 8)
            
            // Discount
            HStack {
                Text("Discount:")
                    .font(.headline)
                Text("\(analysis.currency) \(analysis.formattedDiscount)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                Text("(\(analysis.valuation.formattedMOS))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
            
            // Quality Score and Recommendation
            HStack(spacing: 12) {
                // Quality Score Badge
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(analysis.qualityScore)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.15))
                .cornerRadius(8)
                
                // Recommendation Badge
                RecommendationBadge(recommendation: analysis.recommendation)
            }
            
            // Expandable Details
            DisclosureGroup("View Details", isExpanded: $showDetails) {
                VStack(alignment: .leading, spacing: 12) {
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Key Metrics
                    Text("Key Metrics")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    MetricRow(label: "Gross Margin", value: analysis.metrics.formattedGrossMargin)
                    MetricRow(label: "FCF Margin", value: analysis.metrics.formattedFCFMargin)
                    MetricRow(label: "ROE", value: analysis.metrics.formattedROE)
                    MetricRow(label: "ROIC", value: analysis.metrics.formattedROIC)
                    MetricRow(label: "Interest Coverage", value: analysis.metrics.formattedInterestCoverage)
                    MetricRow(label: "Debt/Equity", value: analysis.metrics.formattedDebtToEquity)
                    
                    Divider()
                        .padding(.vertical, 8)
                    
                    // Quality Checks
                    Text("Quality Checks")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    ForEach(analysis.qualityFlags.allFlags, id: \.0) { flag in
                        QualityCheckRow(label: flag.0, passed: flag.1)
                    }
                }
                .padding(.top, 8)
            }
            .accentColor(.blue)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Recommendation Badge
struct RecommendationBadge: View {
    let recommendation: Recommendation
    
    var badgeColor: Color {
        switch recommendation {
        case .strongBuy: return .green
        case .buy: return Color(red: 0.6, green: 0.8, blue: 0.4)
        case .watch: return .yellow
        case .avoid: return .red
        }
    }
    
    var body: some View {
        Text(recommendation.displayName.uppercased())
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(badgeColor)
            .cornerRadius(8)
    }
}

// MARK: - Metric Row
struct MetricRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

// MARK: - Quality Check Row
struct QualityCheckRow: View {
    let label: String
    let passed: Bool
    
    var body: some View {
        HStack {
            Image(systemName: passed ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(passed ? .green : .red)
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
        }
        .font(.subheadline)
    }
}

