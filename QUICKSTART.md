# Quick Start - Get Running in 5 Minutes

## Prerequisites

- Mac with Xcode 14+ installed
- Backend API running on `http://localhost:8000`

## Option A: Using XcodeGen (Fastest)

```bash
# Install XcodeGen if you haven't
brew install xcodegen

# Navigate to project directory
cd Intrinsic-FE/IntrinsicValue

# Generate Xcode project
./generate-project.sh

# Open in Xcode
open IntrinsicValue.xcodeproj
```

Then in Xcode:

1. Select your team in Signing & Capabilities
2. Press ⌘R to run

## Option B: Manual Xcode Setup (5-10 minutes)

1. **Open Xcode**

2. **Create New Project**
   - iOS App
   - Name: `IntrinsicValue`
   - Interface: SwiftUI
   - Language: Swift

3. **Replace all files**
   - Delete Xcode's default files
   - Drag `IntrinsicValue/IntrinsicValue/*` into Xcode
   - Uncheck "Copy items if needed"
   - Select "Create groups"

4. **Configure**
   - Set deployment target: iOS 16.0
   - Select your team for signing
   - Ensure Info.plist is set correctly

5. **Run** (⌘R)

## Verify It Works

1. **Search Tab**
   - Type "AAPL"
   - Hit Search
   - Should show Apple analysis

2. **Top Picks Tab**
   - Should load list of stocks
   - Pull down to refresh

3. **Settings Tab**
   - Should show API URL
   - Default: <http://localhost:8000>

## Troubleshooting

### "Cannot connect to server"

```bash
# Verify backend is running
curl http://localhost:8000/docs
```

### "Build failed"

- Check all .swift files are in the project target
- Verify iOS deployment target is 16.0+

### Info.plist issues

Add this in Project Settings → Info:

- Key: App Transport Security Settings
  - Allow Arbitrary Loads: YES
  - Allow Local Networking: YES

## File Structure Check

Your project should have:

```
✓ IntrinsicValueApp.swift
✓ Models/Models.swift
✓ Services/APIService.swift
✓ Views/ContentView.swift
✓ Views/SearchView.swift
✓ Views/OpportunitiesView.swift
✓ Views/StockDetailCard.swift
✓ Views/SettingsView.swift
✓ Assets.xcassets/
✓ Info.plist
```

## Next Steps

Once running:

- Test with different tickers
- Check error handling (invalid ticker, no network)
- Try dark mode
- Test on real device (update API URL to your Mac's IP)

## Get Help

See detailed guides:

- [SETUP_GUIDE.md](SETUP_GUIDE.md) - Comprehensive setup instructions
- [PROJECT_OVERVIEW.md](PROJECT_OVERVIEW.md) - Architecture and design
- [README.md](README.md) - Full documentation

---

**Need help?** Check that your backend is running and accessible at the configured URL.
