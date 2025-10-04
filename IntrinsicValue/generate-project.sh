#!/bin/bash

# Generate Xcode Project using XcodeGen
# This is an optional method if you have XcodeGen installed

echo "🚀 Intrinsic Value - Xcode Project Generator"
echo ""

# Check if xcodegen is installed
if ! command -v xcodegen &> /dev/null; then
    echo "❌ XcodeGen not found."
    echo ""
    echo "To install XcodeGen:"
    echo "  brew install xcodegen"
    echo ""
    echo "Or follow the manual setup guide in SETUP_GUIDE.md"
    exit 1
fi

echo "✅ XcodeGen found"
echo "📦 Generating Xcode project..."
echo ""

# Generate the project
xcodegen generate

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Project generated successfully!"
    echo ""
    echo "📱 Next steps:"
    echo "  1. Open IntrinsicValue.xcodeproj in Xcode"
    echo "  2. Select your development team in Signing & Capabilities"
    echo "  3. Make sure your backend API is running on http://localhost:8000"
    echo "  4. Build and run (⌘R)"
    echo ""
else
    echo ""
    echo "❌ Project generation failed"
    echo "Please check the errors above or follow the manual setup in SETUP_GUIDE.md"
    exit 1
fi

