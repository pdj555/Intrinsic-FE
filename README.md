# Intrinsic Value - Buffett Stock Analyzer

A SwiftUI iOS app for analyzing stocks using Warren Buffett-inspired value investing principles.

## Features

- **Stock Search**: Analyze any stock ticker with detailed quality metrics and valuation
- **Top Picks**: Browse S&P 500 stocks ranked by margin of safety
- **Quality Scoring**: 7-point quality check system for business fundamentals
- **Value Recommendations**: Clear buy/sell/watch guidance based on discount to intrinsic value

## Requirements

- iOS 16.0+
- Xcode 14.0+
- Backend API running (see Backend Setup)

## Backend Setup

This app connects to a Python FastAPI backend. Make sure the backend is running before using the app.

Default API endpoint: `http://localhost:8000`

## Installation

### Option 1: Open in Xcode

1. Open `IntrinsicValue/IntrinsicValue.xcodeproj` in Xcode (you'll need to create this project)
2. Select your development team in Signing & Capabilities
3. Build and run on simulator or device

### Option 2: Create Xcode Project Manually

1. Open Xcode
2. Create a new iOS App project
3. Name it "IntrinsicValue"
4. Set Organization Identifier (e.g., com.yourname.intrinsicvalue)
5. Interface: SwiftUI
6. Language: Swift
7. Replace the default files with the files in this repository:
   - Copy all files from `IntrinsicValue/IntrinsicValue/` to your project
   - Make sure to add them to the Xcode project
   - Replace Info.plist with the provided one (enables localhost HTTP)

### File Structure

```
IntrinsicValue/
├── IntrinsicValueApp.swift          # App entry point
├── Models/
│   └── Models.swift                 # API response models
├── Services/
│   └── APIService.swift             # Network layer
├── Views/
│   ├── ContentView.swift            # TabView container
│   ├── SearchView.swift             # Stock search screen
│   ├── OpportunitiesView.swift      # Top picks list
│   ├── StockDetailCard.swift        # Reusable stock detail card
│   └── SettingsView.swift           # Settings and API config
├── Assets.xcassets/                 # App icon and assets
└── Info.plist                       # App configuration
```

## Configuration

### API Base URL

The app allows you to configure the backend API URL in Settings:

1. Open the app
2. Go to Settings tab
3. Enter your API base URL (default: `http://localhost:8000`)
4. Tap Save

### Testing with Localhost

The app is configured to allow HTTP connections to localhost for development. This is enabled in `Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsLocalNetworking</key>
    <true/>
</dict>
```

## Usage

### Search for a Stock

1. Open the Search tab
2. Enter a ticker symbol (e.g., AAPL)
3. Tap Search or press Return
4. View the analysis with:
   - One-sentence summary
   - Current price vs. intrinsic value
   - Discount amount and percentage
   - Quality score (7 checks)
   - Buy/Sell recommendation
   - Expandable detailed metrics

### Browse Top Opportunities

1. Open the Top Picks tab
2. View S&P 500 stocks ranked by margin of safety
3. Pull down to refresh
4. Tap any stock to see full analysis

## API Endpoints

The app uses these backend endpoints:

- `GET /analyze/{ticker}?include_ai=0` - Analyze single stock
- `GET /rank-sp500` - Get top S&P 500 opportunities

## Troubleshooting

### Cannot Connect to Server

- Make sure the backend API is running
- Check the API URL in Settings
- If using iOS simulator, use `http://localhost:8000`
- If using physical device, use your computer's local IP (e.g., `http://192.168.1.10:8000`)

### Build Errors

- Make sure all files are added to the Xcode project target
- Check that iOS deployment target is set to iOS 16.0+
- Verify signing & capabilities are configured

### Network Errors

- Check Info.plist includes NSAppTransportSecurity settings
- Verify localhost networking is allowed
- Check device/simulator has network access

## TestFlight Deployment

Before submitting to TestFlight:

1. Add an app icon (1024x1024 PNG in Assets.xcassets)
2. Update version and build number
3. Update API base URL to production endpoint
4. Test all features thoroughly
5. Archive and upload to App Store Connect

## Architecture

- **SwiftUI** for all UI components
- **async/await** for API calls
- **URLSession** for networking (no third-party dependencies)
- **Codable** for JSON parsing
- **@State** and **@AppStorage** for state management

## License

MIT

## Author

Built for TestFlight deployment - clean, simple, and functional.
