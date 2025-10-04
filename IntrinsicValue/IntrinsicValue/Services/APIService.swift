import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
    case tickerNotFound
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to parse server response"
        case .serverError(let code):
            return "Server error (code \(code))"
        case .tickerNotFound:
            return "Stock ticker not found"
        }
    }
}

class APIService {
    static let shared = APIService()
    
    // Configurable base URL
    var baseURL: String = "http://localhost:8000"
    
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Analyze Single Stock
    func analyzeStock(ticker: String) async throws -> StockAnalysis {
        guard let url = URL(string: "\(baseURL)/analyze/\(ticker.uppercased())?include_ai=0") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200:
                do {
                    let analysis = try JSONDecoder().decode(StockAnalysis.self, from: data)
                    return analysis
                } catch {
                    throw APIError.decodingError(error)
                }
            case 404:
                throw APIError.tickerNotFound
            default:
                throw APIError.serverError(httpResponse.statusCode)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Get Top Opportunities
    func getTopOpportunities() async throws -> [OpportunityItem] {
        guard let url = URL(string: "\(baseURL)/rank-sp500") else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200:
                do {
                    let opportunitiesResponse = try JSONDecoder().decode(TopOpportunitiesResponse.self, from: data)
                    return opportunitiesResponse.items
                } catch {
                    throw APIError.decodingError(error)
                }
            default:
                throw APIError.serverError(httpResponse.statusCode)
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
}

