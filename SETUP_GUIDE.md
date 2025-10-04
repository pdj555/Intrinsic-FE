# Quick Setup Guide

## Creating the Xcode Project

Since Xcode projects are complex binary/XML files, here's the easiest way to set up this project:

### Method 1: Create New Project in Xcode (Recommended)

1. **Open Xcode**
2. **File → New → Project**
3. Select **iOS → App**
4. Configure:
   - Product Name: `IntrinsicValue`
   - Team: (Select your team)
   - Organization Identifier: `com.yourname` (or your preference)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**
   - Uncheck "Include Tests"
5. **Save** in this directory: `Intrinsic-FE/`

6. **Delete default files** Xcode created:
   - Delete `ContentView.swift` (we have our own)
   - Delete `IntrinsicValueApp.swift` (we have our own)
   - Delete `Assets.xcassets` (we have our own)

7. **Add all source files to the project**:
   - Drag the `IntrinsicValue/IntrinsicValue/` folder contents into Xcode
   - Make sure "Copy items if needed" is UNCHECKED
   - Make sure "Create groups" is selected
   - Check the IntrinsicValue target

8. **Replace Info.plist**:
   - In project settings, go to Info tab
   - Add the NSAppTransportSecurity settings (or replace with our Info.plist)

### Method 2: Use the Prepared Files

All source files are ready in the `IntrinsicValue/IntrinsicValue/` directory:

```
IntrinsicValue/IntrinsicValue/
├── IntrinsicValueApp.swift
├── Models/
│   └── Models.swift
├── Services/
│   └── APIService.swift
├── Views/
│   ├── ContentView.swift
│   ├── SearchView.swift
│   ├── OpportunitiesView.swift
│   ├── StockDetailCard.swift
│   └── SettingsView.swift
├── Assets.xcassets/
│   └── AppIcon.appiconset/
└── Info.plist
```

### Project Configuration

**Important Settings in Xcode:**

1. **Deployment Target**: iOS 16.0 or later
2. **Signing**: Select your development team
3. **Bundle Identifier**: com.yourname.IntrinsicValue (or your choice)

### Info.plist Critical Settings

The provided `Info.plist` includes:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsLocalNetworking</key>
    <true/>
</dict>
```

This allows HTTP connections to localhost for development.

## Running the App

1. **Start your backend API** (should be running on `http://localhost:8000`)
2. **Select a simulator** or connected device in Xcode
3. **Press ⌘R** to build and run
4. The app should launch and connect to your local API

## Testing the App

### Test Search Feature

1. Enter a ticker like "AAPL"
2. Tap Search
3. Should see complete analysis

### Test Top Picks

1. Go to Top Picks tab
2. Should load list of stocks
3. Tap any stock to see details

### Test Settings

1. Go to Settings tab
2. Change API URL if needed
3. Tap Save

## Troubleshooting

### "Build Failed" - Missing Files

- Make sure all `.swift` files are added to the target
- Check File Inspector → Target Membership

### "Cannot Connect to Server"

- Verify backend is running: `curl http://localhost:8000/docs`
- Check API URL in Settings tab
- For physical device, use your Mac's IP instead of localhost

### Info.plist Not Working

- In Xcode: Project → Target → Info tab
- Add App Transport Security Settings manually
- Key: `NSAppTransportSecurity`
- Value: Dictionary with `NSAllowsLocalNetworking` = YES

## Adding App Icon

1. Create or download a 1024x1024 PNG image
2. Drag it into `Assets.xcassets/AppIcon.appiconset`
3. Xcode will generate all sizes automatically

Or use SF Symbol as placeholder:

- The app will use system icons if no custom icon is provided

## Next Steps

Once running:

- Test all features thoroughly
- Customize the app icon
- Configure production API URL for TestFlight
- Archive and upload to App Store Connect

## Need Help?

Check that:

- ✅ All Swift files are in the project
- ✅ Files are added to IntrinsicValue target
- ✅ iOS deployment target is 16.0+
- ✅ Signing is configured
- ✅ Backend API is running
- ✅ Info.plist allows localhost networking
