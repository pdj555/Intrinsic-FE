# API Compatibility Report

## Backend API Analysis

After reviewing the backend code at `/Users/p/code/github/intrinsic-value`, I've identified the following mismatches between the backend API and the frontend implementation.

---

## ❌ Critical Mismatches Found

### 1. Quality Flags Field Names

**Backend Returns** (src/metrics_calculator.py:63-72):

```json
{
  "roic_over_10": true,
  "roe_over_12": true,
  "fcf_margin_over_8": true,
  "interest_cover_over_5": true,
  "debt_payable_with_4y_fcf": true,
  "mostly_positive_fcf": true,
  "stable_fcf": true
}
```

**Frontend Expects** (Models.swift - QualityFlags):

```swift
roic_gt_10          // ❌ Should be: roic_over_10
roe_gt_12           // ❌ Should be: roe_over_12
fcf_margin_gt_8     // ❌ Should be: fcf_margin_over_8
interest_coverage_gt_5  // ❌ Should be: interest_cover_over_5
debt_payable_in_4y  // ❌ Should be: debt_payable_with_4y_fcf
mostly_positive_fcf // ✅ Correct
stable_fcf          // ✅ Correct
```

### 2. Recommendation Values

**Backend Returns** (src/valuator.py:61-68):

```python
"Strong Buy"  # With space and capital letters
"Buy"
"Watch"
"Avoid"
```

**Frontend Expects** (Models.swift):

```swift
// User FIXED this! The enum now correctly maps:
case strongBuy = "Strong Buy"  // ✅ Now correct!
case buy = "Buy"               // ✅ Correct
case watch = "Watch"           // ✅ Correct
case avoid = "Avoid"           // ✅ Correct
```

**Status:** ✅ **FIXED by user** - The enum rawValue now matches backend

---

## Required Frontend Fixes

### Fix 1: Update QualityFlags Model (REQUIRED)

File: `IntrinsicValue/IntrinsicValue/Models/Models.swift`

The `QualityFlags` struct needs to match the backend exactly:

```swift
struct QualityFlags: Codable {
    let roicOver10: Bool              // Changed
    let roeOver12: Bool               // Changed
    let fcfMarginOver8: Bool          // Changed
    let interestCoverOver5: Bool      // Changed
    let debtPayableWith4yFcf: Bool    // Changed
    let mostlyPositiveFcf: Bool       // Same
    let stableFcf: Bool               // Same
    
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
```

---

## ✅ Already Correct

### API Endpoints

- ✅ `GET /analyze/{ticker}?include_ai=0` - Correct
- ✅ `GET /rank-sp500` - Correct

### Response Fields

- ✅ `ticker` - String
- ✅ `company_name` - String
- ✅ `summary` - String
- ✅ `currency` - String
- ✅ `price` - Double
- ✅ `discount_dollars` - Double
- ✅ `quality_score` - String (e.g., "7/7 passed")
- ✅ `metrics` - Dictionary with all correct keys
- ✅ `valuation` - All fields correct
- ✅ `recommendation` - Now fixed by user
- ✅ `ai_commentary` - Optional string

### Metrics Keys (All Correct)

- ✅ `gross_margin`
- ✅ `fcf_margin`
- ✅ `roe`
- ✅ `roic`
- ✅ `interest_coverage`
- ✅ `debt_to_equity`
- ✅ `debt`

### Valuation Keys (All Correct)

- ✅ `iv_per_share`
- ✅ `mos_pct`
- ✅ `discount_rate`
- ✅ `terminal_growth`
- ✅ `start_growth`
- ✅ `growth_years`

---

## Testing Recommendations

### 1. Start Backend API

```bash
cd /Users/p/code/github/intrinsic-value
# Using Docker
docker compose up -d

# OR using uvicorn directly
uvicorn src.api:app --reload --port 8000
```

### 2. Test Endpoints

```bash
# Test analyze endpoint
curl http://localhost:8000/analyze/AAPL?include_ai=0 | jq

# Test rank-sp500 endpoint
curl http://localhost:8000/rank-sp500 | jq '.items[:3]'

# Verify quality_flags structure
curl http://localhost:8000/analyze/AAPL?include_ai=0 | jq '.quality_flags'
```

Expected output for quality_flags:

```json
{
  "roic_over_10": true,
  "roe_over_12": true,
  "fcf_margin_over_8": true,
  "interest_cover_over_5": true,
  "debt_payable_with_4y_fcf": true,
  "mostly_positive_fcf": true,
  "stable_fcf": true
}
```

### 3. Test Recommendations

```bash
curl http://localhost:8000/analyze/AAPL?include_ai=0 | jq '.recommendation'
```

Expected values: `"Strong Buy"`, `"Buy"`, `"Watch"`, or `"Avoid"`

---

## Summary

**Issues Found:** 2

1. ❌ Quality flags field names mismatch (7 fields need updating)
2. ✅ Recommendation format (FIXED by user)

**Action Required:**

1. Update `Models.swift` QualityFlags struct to match backend
2. Test with live backend API to verify

**Impact:**

- App will fail to parse quality_flags correctly
- JSON decoding will fail or return incorrect quality check data
- Display will show wrong quality status

**Priority:** 🔴 **CRITICAL** - Must fix before testing

---

## Next Steps

1. ✅ User already fixed Recommendation enum
2. ❌ Update QualityFlags struct (see Fix 1 above)
3. Test with real backend API
4. Verify all responses parse correctly
5. Update StockDetailCard if needed
