import Foundation

// MARK: - Stock Analysis Response
struct StockAnalysis: Codable, Identifiable {
    let ticker: String
    let companyName: String
    let summary: String
    let currency: String
    let price: Double
    let discountDollars: Double
    let qualityScore: String
    let recommendation: Recommendation
    let metrics: Metrics
    let qualityFlags: QualityFlags
    let valuation: Valuation
    let aiCommentary: String?
    
    var id: String { ticker }
    
    enum CodingKeys: String, CodingKey {
        case ticker
        case companyName = "company_name"
        case summary
        case currency
        case price
        case discountDollars = "discount_dollars"
        case qualityScore = "quality_score"
        case recommendation
        case metrics
        case qualityFlags = "quality_flags"
        case valuation
        case aiCommentary = "ai_commentary"
    }
    
    // Formatted display properties
    var formattedPrice: String {
        "\(currency) \(String(format: "%.2f", price))"
    }
    
    var formattedDiscount: String {
        String(format: "%.2f", discountDollars)
    }
    
    var formattedIntrinsicValue: String {
        "\(currency) \(String(format: "%.2f", valuation.ivPerShare))"
    }
}

// MARK: - Metrics
struct Metrics: Codable {
    let grossMargin: Double
    let fcfMargin: Double
    let roe: Double
    let roic: Double
    let interestCoverage: Double
    let debtToEquity: Double
    let debt: Double
    
    enum CodingKeys: String, CodingKey {
        case grossMargin = "gross_margin"
        case fcfMargin = "fcf_margin"
        case roe
        case roic
        case interestCoverage = "interest_coverage"
        case debtToEquity = "debt_to_equity"
        case debt
    }
    
    // Formatted display properties
    var formattedGrossMargin: String {
        String(format: "%.1f%%", grossMargin * 100)
    }
    
    var formattedFCFMargin: String {
        String(format: "%.1f%%", fcfMargin * 100)
    }
    
    var formattedROE: String {
        String(format: "%.1f%%", roe * 100)
    }
    
    var formattedROIC: String {
        String(format: "%.1f%%", roic * 100)
    }
    
    var formattedDebtToEquity: String {
        String(format: "%.2f", debtToEquity)
    }
    
    var formattedInterestCoverage: String {
        String(format: "%.1fx", interestCoverage)
    }
}

// MARK: - Quality Flags
struct QualityFlags: Codable {
    let roicOver10: Bool
    let roeOver12: Bool
    let fcfMarginOver8: Bool
    let interestCoverOver5: Bool
    let debtPayableWith4yFcf: Bool
    let mostlyPositiveFcf: Bool
    let stableFcf: Bool
    
    enum CodingKeys: String, CodingKey {
        case roicOver10 = "roic_over_10"
        case roeOver12 = "roe_over_12"
        case fcfMarginOver8 = "fcf_margin_over_8"
        case interestCoverOver5 = "interest_cover_over_5"
        case debtPayableWith4yFcf = "debt_payable_with_4y_fcf"
        case mostlyPositiveFcf = "mostly_positive_fcf"
        case stableFcf = "stable_fcf"
    }
    
    var allFlags: [(String, Bool)] {
        [
            ("ROIC > 10%", roicOver10),
            ("ROE > 12%", roeOver12),
            ("FCF Margin > 8%", fcfMarginOver8),
            ("Interest Coverage > 5x", interestCoverOver5),
            ("Debt Payable with 4Y FCF", debtPayableWith4yFcf),
            ("Mostly Positive FCF", mostlyPositiveFcf),
            ("Stable FCF", stableFcf)
        ]
    }
}

// MARK: - Valuation
struct Valuation: Codable {
    let ivPerShare: Double
    let mosPct: Double
    let discountRate: Double
    let terminalGrowth: Double
    let startGrowth: Double
    let growthYears: Int
    
    enum CodingKeys: String, CodingKey {
        case ivPerShare = "iv_per_share"
        case mosPct = "mos_pct"
        case discountRate = "discount_rate"
        case terminalGrowth = "terminal_growth"
        case startGrowth = "start_growth"
        case growthYears = "growth_years"
    }
    
    var formattedMOS: String {
        String(format: "%.0f%%", mosPct * 100)
    }
}

// MARK: - Recommendation
enum Recommendation: String, Codable {
    case strongBuy = "STRONG_BUY"
    case buy = "BUY"
    case watch = "WATCH"
    case avoid = "AVOID"
    
    var displayName: String {
        switch self {
        case .strongBuy: return "Strong Buy"
        case .buy: return "Buy"
        case .watch: return "Watch"
        case .avoid: return "Avoid"
        }
    }
}

// MARK: - Top Opportunities Response
struct TopOpportunitiesResponse: Codable {
    let items: [OpportunityItem]
}

struct OpportunityItem: Codable, Identifiable {
    let ticker: String
    let companyName: String
    let mosPct: Double
    let price: Double
    let ivPerShare: Double
    let recommendation: Recommendation
    
    var id: String { ticker }
    
    enum CodingKeys: String, CodingKey {
        case ticker
        case companyName = "company_name"
        case mosPct = "mos_pct"
        case price
        case ivPerShare = "iv_per_share"
        case recommendation
    }
    
    var formattedMOS: String {
        String(format: "%.0f%%", mosPct * 100)
    }
    
    var formattedPrice: String {
        String(format: "$%.2f", price)
    }
}

