# Quick Start Guide

## 🚀 Running Tests with Tags and Profiles

### Run Smoke Tests
```bash
cucumber -p smoke
```

### Run API Tests
```bash
cucumber -p api
```

### Run Security Tests
```bash
cucumber -p security
```

### Run UI Tests on Android
```bash
PLATFORM=android cucumber -p ui
```

### Run UI Tests on iOS
```bash
PLATFORM=ios cucumber -p ui
```

### Run Tests with Tags
```bash
# Single tag
cucumber --tags @smoke

# Multiple tags (AND)
cucumber --tags "@ui and @positive"

# Exclude tags (NOT)
cucumber --tags "not @negative"
```

### Run 1 Test Per Category (Like Bitrise)
```bash
# Unit test
bundle exec rspec spec/unit/appium_config_spec.rb --example "returns Android capabilities"

# API test
bundle exec cucumber features/api_tests.feature:7

# Security test
bundle exec cucumber features/security_tests.feature:7

# UI test (Android)
PLATFORM=android bundle exec cucumber features/ui_login.feature:11

# UI test (iOS)
PLATFORM=ios bundle exec cucumber features/ui_login.feature:11
```

## 📦 Release Train

### Start Standard Release Train
1. Go to GitHub Actions
2. Click "Release Train"
3. Run workflow:
   - Release Type: `release_train`
   - Version: `1.0.0`

### Start Hotfix (Immediate)
1. Go to GitHub Actions
2. Click "Release Train"
3. Run workflow:
   - Release Type: `hotfix`
   - Version: `1.0.1-hotfix`

### Stop Release Train
1. Get Run ID from GitHub Actions
2. Click "Stop Release Train"
3. Enter Run ID and reason

### Replace Release Train
1. Get current Run ID
2. Click "Replace Release Train"
3. Enter:
   - Current Run ID
   - New Version
   - Start from stage
   - Reason

## 📊 View Reports

### HTML Reports
```bash
# After running tests
open reports/cucumber_report.html
open reports/smoke_report.html
open reports/api_report.html
```

### Allure Reports
```bash
allure serve allure-results
```

## 🔧 Bitrise CI/CD (FREE)

### Available Workflows
- `primary` - Run 1 test per category (Android + iOS)
- `smoke_tests` - Quick smoke tests
- `api_tests` - API tests only
- `unit_tests` - RSpec unit tests
- `build_android_release` - Build Android APK
- `build_ios_release` - Build iOS IPA
- `deploy_to_firebase` - Deploy to Firebase
- `deploy_to_testflight` - Deploy to TestFlight
- `deploy_to_production` - Production release

### Trigger Bitrise Build
```bash
curl -X POST "https://app.bitrise.io/app/YOUR_APP_SLUG/build/start.json" \
  -H "Authorization: YOUR_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "hook_info": {"type": "bitrise"},
    "build_params": {
      "branch": "master",
      "workflow_id": "primary"
    }
  }'
```

## 🧪 Test Categories

### Unit Tests
```bash
bundle exec rspec spec/unit
```

### Integration Tests
```bash
bundle exec rspec spec/integration
```

### UI Tests
```bash
cucumber -p ui
```

### API Tests
```bash
cucumber -p api
```

### Security Tests
```bash
cucumber -p security
```

## 📱 Platform-Specific

### Android Only
```bash
PLATFORM=android cucumber
```

### iOS Only
```bash
PLATFORM=ios cucumber
```

## 🛠️ Rake Tasks

```bash
rake                  # Run all tests
rake smoke            # Smoke tests
rake ui_tests         # UI tests
rake api_tests        # API tests
rake security_tests   # Security tests
rake full_suite       # Full test suite
rake clean            # Clean artifacts
```

## 📋 Release Train Timeline

```
X hrs      → Build Release
X + 2 hrs  → Internal Testers
X + 4 hrs  → Friends & Family
X + 8 hrs  → Beta Testers
X + 10 hrs → Submit for Review
X + 12 hrs → Production Release
```

## 🚨 Hotfix Timeline

```
Immediate → Build → Internal → Beta → Review → Production
(All stages execute without delays)
```

## 📚 Documentation

- `README.md` - Project overview
- `TEST_EXECUTION_GUIDE.md` - Detailed test execution
- `RELEASE_TRAIN_GUIDE.md` - Complete release train guide
- `CICD_SETUP.md` - Bitrise setup (FREE tier info)

## 🔑 Required Secrets

### GitHub Secrets
```
BITRISE_API_TOKEN
BITRISE_APP_SLUG
BITRISE_IOS_APP_SLUG
FIREBASE_TOKEN
FIREBASE_ANDROID_APP_ID
FIREBASE_IOS_APP_ID
```

### Bitrise Environment Variables
```
VERSION
PROJECT_LOCATION
BITRISE_PROJECT_PATH
BITRISE_SCHEME
ANDROID_PACKAGE_NAME
```

## ⚡ Quick Commands

```bash
# Install dependencies
bundle install

# Run smoke tests with report
cucumber -p smoke

# Run all tests with reports
cucumber

# Run unit tests
bundle exec rspec

# View HTML report
open reports/cucumber_report.html

# Generate Allure report
allure serve allure-results

# Clean artifacts
rake clean

# Full test suite
rake full_suite
```

## 🎯 Common Scenarios

### Scenario 1: Quick Validation
```bash
cucumber -p smoke
```

### Scenario 2: Full Test Run
```bash
rake full_suite
```

### Scenario 3: API Only
```bash
cucumber -p api
```

### Scenario 4: Android UI Tests
```bash
PLATFORM=android cucumber -p ui
```

### Scenario 5: Release to Production
1. GitHub Actions → Release Train
2. Release Type: `release_train`
3. Version: `1.0.0`
4. Wait 12 hours (or skip stages)

### Scenario 6: Emergency Hotfix
1. GitHub Actions → Release Train
2. Release Type: `hotfix`
3. Version: `1.0.1-hotfix`
4. All stages execute immediately

## 💡 Tips

1. **Use profiles** for consistent reporting
2. **Run smoke tests first** for quick feedback
3. **Use tags** for precise test selection
4. **Check HTML reports** for detailed results
5. **Use Allure** for rich, interactive reports
6. **Bitrise is FREE** for 200 builds/month
7. **Release train** automates entire release process
8. **Hotfix** bypasses time delays for emergencies
