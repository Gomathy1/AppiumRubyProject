# Appium Ruby Test Automation Framework

A comprehensive mobile test automation framework using Appium, Ruby, and Cucumber BDD for testing Android and iOS applications.

## Features

- **Cross-Platform Testing**: Support for both Android and iOS
- **BDD Framework**: Cucumber for behavior-driven development
- **Page Object Model**: Clean and maintainable page objects
- **Parallel Execution**: Run tests in parallel using parallel_tests
- **API Testing**: REST API testing capabilities
- **Rich Reporting**: Allure and HTML reports
- **Code Quality**: RuboCop for code style, SimpleCov for coverage
- **Flexible Configuration**: Environment-based configuration using dotenv

## Prerequisites

- Ruby 3.0 or higher
- Node.js and npm (for Appium)
- Appium Server 2.x
- Android SDK (for Android testing)
- Xcode (for iOS testing on macOS)
- Java JDK 11 or higher

## Installation

### 1. Install Ruby Dependencies

```bash
bundle install
```

### 2. Install Appium

```bash
npm install -g appium
appium driver install uiautomator2  # For Android
appium driver install xcuitest      # For iOS
```

### 3. Configure Environment

Copy `.env.example` to `.env` and update the values:

```bash
cp .env.example .env
```

Edit `.env` with your specific configuration:
- Device names
- Platform versions
- App paths
- Appium server URL

## Project Structure

```
AppiumRubyProject/
├── config/                 # Configuration files
│   └── appium_config.rb   # Appium capabilities
├── features/              # Cucumber feature files
│   ├── step_definitions/  # Step definitions
│   ├── support/          # Support files (hooks, env)
│   └── *.feature         # Feature files
├── lib/
│   ├── pages/            # Page objects
│   └── utils/            # Utility classes
├── spec/                 # RSpec unit tests
├── apps/                 # Mobile apps (create this folder)
│   ├── android/
│   └── ios/
├── .env                  # Environment variables
├── Gemfile              # Ruby dependencies
└── README.md            # This file
```

## Running Tests

### Run All Tests

```bash
cucumber
```

### Run Specific Feature

```bash
cucumber features/ui_login.feature
```

### Run Tests with Tags

```bash
# Run smoke tests
cucumber --tags @smoke

# Run UI tests
cucumber --tags @ui

# Run positive tests
cucumber --tags @positive

# Exclude negative tests
cucumber --tags "not @negative"
```

### Run Tests in Parallel

```bash
parallel_cucumber features/ -n 2
```

### Run on Different Platforms

```bash
# Android
PLATFORM=android cucumber

# iOS
PLATFORM=ios cucumber
```

## Reporting

### Generate Allure Report

```bash
# Run tests with Allure
cucumber --format AllureCucumber::CucumberFormatter

# Generate and open report
allure serve allure-results
```

### HTML Report

```bash
cucumber --format html --out reports/cucumber_report.html
```

## Code Quality

### Run RuboCop

```bash
rubocop
```

### Auto-fix RuboCop Issues

```bash
rubocop -a
```

### Run SimpleCov for Coverage

Coverage is automatically generated when running tests. Check `coverage/index.html`.

## API Testing

The framework includes REST API testing capabilities. Example:

```ruby
require 'rest-client'
require 'json'

response = RestClient.get("#{ENV['API_BASE_URL']}/posts/1")
data = JSON.parse(response.body)
```

## Writing Tests

### 1. Create a Feature File

```gherkin
Feature: Product Search
  Scenario: Search for a product
    Given I am on the home page
    When I search for "Backpack"
    Then I should see search results
```

### 2. Create Page Object

```ruby
class ProductPage < BasePage
  def search_field
    { accessibility_id: 'search-field' }
  end

  def search(query)
    send_keys(search_field, query)
  end
end
```

### 3. Create Step Definitions

```ruby
Given('I am on the home page') do
  @product_page = ProductPage.new
end

When('I search for {string}') do |query|
  @product_page.search(query)
end
```

## Best Practices

1. **Use Page Object Model**: Keep locators and actions in page objects
2. **Use Accessibility IDs**: Prefer accessibility IDs over XPath
3. **Wait Strategies**: Use explicit waits for dynamic elements
4. **Independent Tests**: Each test should be independent
5. **Clean Test Data**: Reset app state between tests
6. **Meaningful Names**: Use descriptive names for methods and variables

## Troubleshooting

### Appium Server Not Running

```bash
appium
```

### Device Not Found

Check connected devices:
```bash
# Android
adb devices

# iOS
xcrun simctl list devices
```

### App Not Installing

Verify app path in `.env` file and ensure the app file exists.

## Contributing

1. Follow Ruby style guide
2. Write tests for new features
3. Run RuboCop before committing
4. Update documentation

## Release Train 🚂

This project includes an automated **Release Train** system for managing releases:

### Quick Start

**Standard Release (12-hour timeline):**
```bash
GitHub Actions → Release Train → Run workflow
- Release Type: release_train
- Version: 1.0.0
```

**Hotfix (Immediate):**
```bash
GitHub Actions → Release Train → Run workflow
- Release Type: hotfix
- Version: 1.0.1-hotfix
```

### Release Stages

1. **X hrs** - Build Release from Master
2. **X + 2 hrs** - Deploy to Internal Testers
3. **X + 4 hrs** - Deploy to Friends & Family
4. **X + 8 hrs** - Deploy to Beta Testers
5. **X + 10 hrs** - Submit for App Store/Play Store Review
6. **X + 12 hrs** - Release to Production

### Advanced Controls

- **Stop Release Train** - Cancel running release
- **Replace Release Train** - Stop current and start new release
- **Skip to Stage** - Resume from specific stage
- **Stop at Stage** - Run only up to specific stage

See `RELEASE_TRAIN_GUIDE.md` for complete documentation.

## Test Execution with Bitrise

The project runs **1 test per category** on both Android emulator and iOS simulator:

### Tests Executed
- ✅ 1 Unit Test
- ✅ 1 API Test
- ✅ 1 Security Test
- ✅ 1 Android UI Test (Emulator)
- ✅ 1 iOS UI Test (Simulator)

### Bitrise Workflows
- `primary` - Run all test categories
- `build_android_release` - Build Android APK
- `build_ios_release` - Build iOS IPA
- `deploy_to_firebase` - Deploy to Firebase
- `deploy_to_testflight` - Deploy to TestFlight
- `deploy_to_production` - Production release

**Bitrise is FREE** for 200 builds/month!

## Quick Reference

### Run Tests with Profiles
```bash
cucumber -p smoke      # Smoke tests
cucumber -p api        # API tests
cucumber -p security   # Security tests
cucumber -p ui         # UI tests
```

### Run Tests with Tags
```bash
cucumber --tags @smoke                    # Single tag
cucumber --tags "@ui and @positive"       # Multiple tags (AND)
cucumber --tags "not @negative"           # Exclude tags (NOT)
```

### Platform-Specific
```bash
PLATFORM=android cucumber -p ui           # Android tests
PLATFORM=ios cucumber -p ui               # iOS tests
```

### View Reports
```bash
open reports/cucumber_report.html         # HTML report
allure serve allure-results               # Allure report
```

## Fully Automated CI/CD 🤖

This project includes **100% automated CI/CD** with zero human intervention:

### What's Automated

✅ **PR Checks** - Runs automatically on every PR
- Code quality (RuboCop)
- Unit tests (RSpec)
- API tests (Cucumber)
- Security tests (Cucumber)
- Mobile tests (Bitrise - Android + iOS)

✅ **Metrics & Reporting** - Posted automatically to PR
- Test results dashboard
- Pass/fail status
- Duration and coverage
- Links to detailed reports

✅ **Email Notifications** - Sent automatically
- All checks passed ✅
- Some checks failed ❌
- PR auto-merged ✅
- Release train started �
- Any pipeline failure ❌

✅ **Auto-Merge** - When all checks pass
- Add `auto-merge` label to PR
- All checks pass → Automatically merged
- Email notification sent

✅ **Auto-Release** - When merged to master
- Include `[release]` in commit message
- Merged to master → Release train triggered
- 12-hour automated release pipeline

### Setup (30 minutes)

See `SETUP_CHECKLIST.md` for complete setup guide.

**Quick Setup:**
1. Add GitHub secrets (email, Bitrise tokens)
2. Configure Bitrise (upload bitrise.yml)
3. Create test PR
4. Watch automation work!

### Architecture

**GitHub Actions** (Fast tests - 6-10 mins):
- Code quality, unit, API, security tests
- FREE: Unlimited for public, 2000 mins/month private

**Bitrise** (Mobile tests - 15-20 mins):
- Android emulator + iOS simulator tests
- FREE: 200 builds/month

**Total: $0/month** 🎉

## Documentation

- �📖 `README.md` - This file (project overview)
- ✅ `SETUP_CHECKLIST.md` - **START HERE** - 30-min setup guide
- 🏗️ `CICD_ARCHITECTURE.md` - Complete CI/CD architecture
- 🧪 `TEST_EXECUTION_GUIDE.md` - How to run tests with tags/profiles
- 🚂 `RELEASE_TRAIN_GUIDE.md` - Complete release train documentation
- 🔧 `CICD_SETUP.md` - Bitrise CI/CD setup (FREE tier)
- ⚡ `QUICK_START.md` - Quick reference guide
- 📊 `PROJECT_SUMMARY.md` - Complete project summary

## License

MIT License
