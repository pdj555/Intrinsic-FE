# TestFlight Deployment Guide

## 🎯 Complete Workflow: Cursor → Local Testing → TestFlight

---

## Step 1: Local Development & Testing (Do This First!)

### A. Development in Cursor ✅

**Yes, you can develop in Cursor!** Here's how:

#### Edit Swift Files in Cursor

```bash
# Open the project in Cursor
cd /Users/p/code/github/Intrinsic-FE
cursor .

# Edit any Swift file:
cursor IntrinsicValue/IntrinsicValue/Models/Models.swift
cursor IntrinsicValue/IntrinsicValue/Views/SearchView.swift
# etc.
```

**What you can do in Cursor:**

- ✅ Edit all Swift files
- ✅ Modify UI components
- ✅ Update models and logic
- ✅ Change API service
- ✅ Edit Info.plist
- ✅ Update documentation

**What you need Xcode for:**

- Building and running the app
- Debugging on simulator/device
- Managing signing & certificates
- Archiving for TestFlight
- Viewing UI previews (SwiftUI canvas)

### B. Set Up Xcode Project (One-Time Setup)

You must create the Xcode project file to build/run:

#### Option 1: Using XcodeGen (Easiest)

```bash
cd /Users/p/code/github/Intrinsic-FE/IntrinsicValue

# Install XcodeGen if needed
brew install xcodegen

# Generate project
./generate-project.sh

# This creates IntrinsicValue.xcodeproj
```

#### Option 2: Manual Xcode Setup

```bash
# Open Xcode
open -a Xcode

# Then follow these steps:
# 1. File → New → Project
# 2. iOS App, SwiftUI, Swift
# 3. Name: IntrinsicValue
# 4. Save in: /Users/p/code/github/Intrinsic-FE/IntrinsicValue/
# 5. Delete Xcode's default files
# 6. Add all files from IntrinsicValue/IntrinsicValue/
# 7. Make sure all .swift files are in the target
```

### C. Test Locally

#### 1. Start Your Backend

```bash
# Terminal 1: Start backend API
cd /Users/p/code/github/intrinsic-value
docker compose up -d

# Verify it's running
curl http://localhost:8000/healthz
# Should return: {"ok": true}
```

#### 2. Open in Xcode

```bash
# Open the project
cd /Users/p/code/github/Intrinsic-FE/IntrinsicValue
open IntrinsicValue.xcodeproj
```

#### 3. Run on Simulator

In Xcode:

1. Select iPhone simulator (e.g., iPhone 15 Pro)
2. Press **⌘R** (or click Play button)
3. App launches in simulator

#### 4. Test Features

- Search for "AAPL" → Should show analysis
- Go to Top Picks → Should load list
- Test Settings → Change API URL
- Test error handling → Try invalid ticker

#### 5. Test on Physical Device (Optional but Recommended)

1. Connect your iPhone via USB
2. Xcode → Select your device
3. First time: Trust computer on iPhone
4. Update Settings → API URL to your Mac's IP:

   ```bash
   # Find your Mac's IP
   ipconfig getifaddr en0
   # Example: 192.168.1.10
   ```

5. In app Settings: `http://192.168.1.10:8000`
6. Run app (⌘R)

---

## Step 2: Prepare for TestFlight

### A. Create App Icon

You need a **1024x1024 PNG** icon:

```bash
# Create a simple icon or use a design tool
# Place it in: IntrinsicValue/IntrinsicValue/Assets.xcassets/AppIcon.appiconset/

# Xcode will automatically generate all sizes
```

**Quick placeholder:** Use an SF Symbol screenshot at 1024x1024

- Open SF Symbols app
- Find `chart.line.uptrend.xyaxis`
- Export at large size
- Scale to 1024x1024

### B. Configure for Production

#### 1. Update API URL

If you have a production backend, update the default:

```swift
// IntrinsicValue/IntrinsicValue/Services/APIService.swift
var baseURL: String = "https://your-production-api.com"
```

Or use localhost for TestFlight internal testing.

#### 2. Update Version Info

In Xcode:

1. Select project in navigator
2. Select "IntrinsicValue" target
3. General tab
4. Update:
   - **Version:** 1.0.0
   - **Build:** 1

### C. Configure Signing

In Xcode:

1. Select project → IntrinsicValue target
2. **Signing & Capabilities** tab
3. **Team:** Select your Apple Developer account
4. **Bundle Identifier:** `com.yourname.IntrinsicValue`
   - Must be unique
   - Can't contain spaces or special characters
5. Enable **Automatically manage signing** ✅

**Don't have Apple Developer account?**

- You can test on simulator without one
- For TestFlight, you need: [Apple Developer Program ($99/year)](https://developer.apple.com/programs/)

---

## Step 3: Archive for TestFlight

### A. Create Archive

In Xcode:

1. Select **Any iOS Device (arm64)** as destination
   - NOT a simulator
   - Not a specific device
2. **Product** → **Archive**
3. Wait for build to complete (2-5 minutes)

**If build fails:**

- Check all Swift files are in target
- Verify signing is configured
- Fix any compiler errors
- See troubleshooting below

### B. Validate Archive

1. **Window** → **Organizer** (⌘⌥⇧O)
2. Select your archive
3. Click **Validate App**
4. Choose distribution method: **App Store Connect**
5. Follow prompts:
   - Re-sign if needed
   - Check for issues
6. Wait for validation

**Validation checks:**

- Code signing correct
- No missing assets
- Info.plist valid
- Binary valid

### C. Upload to App Store Connect

1. In Organizer, click **Distribute App**
2. Choose **App Store Connect**
3. Select **Upload**
4. Review details:
   - Bundle ID correct
   - Version correct
   - Signing correct
5. Click **Upload**
6. Wait (can take 5-30 minutes)

---

## Step 4: TestFlight Setup in App Store Connect

### A. Create App Record

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. **My Apps** → **+** → **New App**
3. Fill in:
   - **Platform:** iOS
   - **Name:** Intrinsic Value (or your choice)
   - **Primary Language:** English
   - **Bundle ID:** Select the one you used
   - **SKU:** any unique identifier (e.g., `intrinsic-value-001`)
4. Click **Create**

### B. Configure TestFlight

Once upload is complete:

1. Go to your app in App Store Connect
2. Click **TestFlight** tab
3. Wait for "Processing" to complete (can take 10-60 min)
4. Build appears under **iOS builds**

### C. Add Test Information

Required before you can test:

1. Click on your build
2. **Test Information** section:
   - **What to Test:** Brief description

     ```
     Test stock analysis features:
     - Search for any ticker (e.g., AAPL)
     - Browse top S&P 500 opportunities
     - Check valuation calculations
     - Verify quality score display
     ```

   - **Beta App Description:** What your app does
   - **Feedback Email:** Your email
   - **Privacy Policy URL:** (optional for internal testing)

### D. Add Testers

#### Internal Testing (Fast, no review)

1. TestFlight → **Internal Testing**
2. Create new group: "Team"
3. Add testers (must have App Store Connect access)
4. Testers get email immediately
5. Can install via TestFlight app

#### External Testing (Requires Apple review, ~24hrs)

1. TestFlight → **External Testing**
2. Create new group: "Beta Testers"
3. Add testers via email (up to 10,000)
4. Submit for review
5. Wait for Apple approval (~1 day)
6. Testers get invite email

---

## Step 5: Install TestFlight Build

### A. Tester Setup

1. Install **TestFlight** app from App Store
2. Check email for invite
3. Click invite link
4. Opens TestFlight
5. Accept invitation
6. Install app

### B. Testing

Test everything:

- ✅ Search various tickers
- ✅ View top opportunities
- ✅ Check quality scores
- ✅ Test all recommendation types
- ✅ Verify error handling
- ✅ Test dark mode
- ✅ Check on different iOS versions
- ✅ Test on WiFi and cellular

### C. Submit Feedback

In TestFlight app:

- Tap app
- **Send Feedback**
- Describe issue or suggestion
- Optionally include screenshot

---

## Development Workflow

### Day-to-Day Development

```bash
# 1. Edit code in Cursor (your preferred editor)
cd /Users/p/code/github/Intrinsic-FE
cursor IntrinsicValue/IntrinsicValue/Views/SearchView.swift

# 2. Make changes, save

# 3. Switch to Xcode to build & run
# Press ⌘R in Xcode

# 4. Test in simulator

# 5. Back to Cursor for more editing

# Repeat!
```

**Pro tip:** Keep both open:

- **Cursor:** For editing code (better AI assistance, familiar)
- **Xcode:** For building and running (required for iOS)

### When to Use Each Tool

| Task | Tool | Why |
|------|------|-----|
| Edit Swift code | Cursor | Better editor, AI help |
| Edit UI layouts | Cursor or Xcode | Both work |
| View SwiftUI preview | Xcode | Live preview canvas |
| Build & run | Xcode | Required |
| Debug crashes | Xcode | Debugger tools |
| Fix compile errors | Cursor or Xcode | Either works |
| Test on device | Xcode | Manages deployment |
| Archive for release | Xcode | Required |
| Update docs | Cursor | Better for markdown |

---

## Troubleshooting

### "Build Failed" in Xcode

**Check:**

1. All Swift files added to target
   - Select file → File Inspector → Target Membership ✅
2. No syntax errors
   - Build output shows specific errors
3. Info.plist in correct location
4. Signing configured

### "Failed to Install"

**Solutions:**

- Clean build folder: ⌘⇧K
- Delete derived data: Xcode → Preferences → Locations → Derived Data → Delete
- Restart Xcode
- Restart simulator

### "Signing Error"

**Solutions:**

- Select team in Signing & Capabilities
- Change bundle identifier to something unique
- Make sure Developer account is valid
- Try "Automatically manage signing"

### "Archive Failed"

**Check:**

- Build destination is "Any iOS Device"
- Not building for simulator
- All architectures included
- Version/build numbers set

### "Upload Failed"

**Common issues:**

- Invalid Info.plist → Check NSAppTransportSecurity
- Missing icons → Add app icon
- Wrong architecture → Must include arm64
- Code signing issue → Re-sign in Xcode

---

## Checklist: Ready for TestFlight?

### Code ✅

- [ ] All features work locally
- [ ] Tested on simulator
- [ ] Tested on real device
- [ ] Error handling works
- [ ] Loading states smooth
- [ ] No crashes

### Assets ✅

- [ ] App icon added (1024x1024)
- [ ] Launch screen configured
- [ ] All images included

### Configuration ✅

- [ ] Info.plist correct
- [ ] API URL set (production or test)
- [ ] Version number set
- [ ] Build number set
- [ ] Bundle ID unique

### Account Setup ✅

- [ ] Apple Developer account active
- [ ] Team selected in Xcode
- [ ] Signing configured
- [ ] Certificates valid

### App Store Connect ✅

- [ ] App record created
- [ ] Test information filled
- [ ] Testers added
- [ ] Privacy info complete

---

## Timeline

**Realistic timeline for first TestFlight build:**

| Stage | Time | Notes |
|-------|------|-------|
| Local testing | 1-2 hours | Test thoroughly |
| Create app icon | 30 min | Or use placeholder |
| Configure Xcode | 15 min | Signing, version |
| Archive build | 5 min | First time |
| Upload to ASC | 10-30 min | Depends on connection |
| Processing | 10-60 min | Apple processes build |
| Add test info | 10 min | Required fields |
| Internal testing | Immediate | Can start right away |
| External review | 24 hours | Apple reviews |
| **Total (internal)** | **2-4 hours** | Same day! |
| **Total (external)** | **1-2 days** | With review |

---

## Quick Commands Reference

### Start Backend

```bash
cd /Users/p/code/github/intrinsic-value
docker compose up -d
```

### Edit in Cursor

```bash
cd /Users/p/code/github/Intrinsic-FE
cursor .
```

### Open in Xcode

```bash
cd /Users/p/code/github/Intrinsic-FE/IntrinsicValue
open IntrinsicValue.xcodeproj
```

### Build & Run

- In Xcode: Press **⌘R**

### Archive

- In Xcode: Product → Archive

### Find Mac IP (for device testing)

```bash
ipconfig getifaddr en0
```

---

## Summary

### Can you develop in Cursor? ✅ YES

- Edit all Swift files in Cursor
- Use Xcode only for building/running
- Keep both open for best workflow

### Can you test locally first? ✅ YES! (Required!)

- Test on simulator
- Test on device
- Fix all issues before TestFlight

### How to get on TestFlight? 📱

1. Test locally until perfect
2. Create app icon
3. Archive in Xcode
4. Upload to App Store Connect
5. Add test info
6. Invite testers
7. Start testing!

---

**Ready to start?** Begin with local testing first! 🚀

Need help with any step? Just ask!
