# Test Execution Guide

## Running Tests with Cucumber Tags and Profiles

### Using Cucumber Profiles

Profiles are pre-configured test execution settings defined in `cucumber.yml`.

#### Available Profiles

##### 1. Default Profile (All Tests)
```bash
cucumber
# or
bundle exec cucumber
```
**Generates:**
- `reports/cucumber_report.html` - HTML report
- `reports/cucumber.json` - JSON report
- `allure-results/` - Allure report data

##### 2. Smoke Tests
```bash
cucumber -p smoke
# or
bundle exec cucumber --profile smoke
```
**Generates:**
- `reports/smoke_report.html`
- `reports/smoke.json`

##### 3. UI Tests
```bash
cucumber -p ui
```
**Generates:**
- `reports/ui_report.html`
- `reports/ui.json`

##### 4. API Tests
```bash
cucumber -p api
```
**Generates:**
- `reports/api_report.html`
- `reports/api.json`

##### 5. Security Tests
```bash
cucumber -p security
```
**Generates:**
- `reports/security_report.html`
- `reports/security.json`

##### 6. Positive Tests
```bash
cucumber -p positive
```
**Generates:**
- `reports/positive_report.html`

##### 7. Negative Tests
```bash
cucumber -p negative
```
**Generates:**
- `reports/negative_report.html`

##### 8. Android Tests
```bash
cucumber -p android
# or
PLATFORM=android cucumber -p ui
```
**Generates:**
- `reports/android_report.html`

##### 9. iOS Tests
```bash
cucumber -p ios
# or
PLATFORM=ios cucumber -p ui
```
**Generates:**
- `reports/ios_report.html`

##### 10. CI Profile
```bash
cucumber -p ci
```
**Features:**
- Strict mode (fails on undefined steps)
- Full reporting
- Suitable for CI/CD pipelines

### Using Cucumber Tags

Tags allow you to run specific subsets of tests.

#### Single Tag
```bash
# Run all smoke tests
cucumber --tags @smoke

# Run all UI tests
cucumber --tags @ui

# Run all API tests
cucumber --tags @api

# Run all security tests
cucumber --tags @security

# Run all positive tests
cucumber --tags @positive

# Run all negative tests
cucumber --tags @negative
```

#### Multiple Tags (AND)
```bash
# Run tests that are BOTH @ui AND @smoke
cucumber --tags "@ui and @smoke"

# Run tests that are BOTH @positive AND @mobile
cucumber --tags "@positive and @mobile"
```

#### Multiple Tags (OR)
```bash
# Run tests that are EITHER @smoke OR @positive
cucumber --tags "@smoke or @positive"

# Run tests that are EITHER @api OR @security
cucumber --tags "@api or @security"
```

#### Exclude Tags (NOT)
```bash
# Run all tests EXCEPT @negative
cucumber --tags "not @negative"

# Run all tests EXCEPT @security
cucumber --tags "not @security"

# Run @ui tests but NOT @negative
cucumber --tags "@ui and not @negative"
```

#### Complex Tag Combinations
```bash
# Run @ui tests that are @smoke but not @negative
cucumber --tags "@ui and @smoke and not @negative"

# Run either @smoke or @positive tests
cucumber --tags "@smoke or @positive"

# Run @mobile tests that are either @android or @ios
cucumber --tags "@mobile and (@android or @ios)"
```

### Combining Profiles and Tags

```bash
# Use smoke profile with additional tag filtering
cucumber -p smoke --tags "@positive"

# Use UI profile but exclude negative tests
cucumber -p ui --tags "not @negative"

# Use API profile with specific tag
cucumber -p api --tags "@performance"
```

### Running Specific Features

#### Single Feature File
```bash
cucumber features/ui_login.feature
```

#### Multiple Feature Files
```bash
cucumber features/ui_login.feature features/ui_products.feature
```

#### Specific Scenario by Line Number
```bash
cucumber features/ui_login.feature:11
```

#### Feature with Profile
```bash
cucumber -p smoke features/ui_login.feature
```

### Parallel Execution

```bash
# Run tests in parallel (2 processes)
parallel_cucumber features/ -n 2

# Run tests in parallel (4 processes)
parallel_cucumber features/ -n 4

# Run specific tag in parallel
parallel_cucumber features/ -n 2 -o "--tags @smoke"
```

### Platform-Specific Execution

#### Android
```bash
PLATFORM=android cucumber -p ui
# or
export PLATFORM=android
cucumber -p ui
```

#### iOS
```bash
PLATFORM=ios cucumber -p ui
# or
export PLATFORM=ios
cucumber -p ui
```

### Using Rake Tasks

```bash
# Run all tests
rake

# Run RuboCop
rake rubocop

# Run unit tests
rake unit_tests

# Run integration tests
rake integration_tests

# Run all RSpec tests
rake spec

# Run smoke tests
rake smoke

# Run UI tests
rake ui_tests

# Run API tests
rake api_tests

# Run security tests
rake security_tests

# Run all Cucumber tests
rake cucumber

# Run tests in parallel
rake parallel

# Generate Allure report
rake allure_report

# Clean test artifacts
rake clean

# Run full test suite
rake full_suite
```

## Viewing Reports

### HTML Reports

After test execution, open reports in browser:

```bash
# Cucumber HTML report
open reports/cucumber_report.html

# Smoke tests report
open reports/smoke_report.html

# UI tests report
open reports/ui_report.html

# API tests report
open reports/api_report.html

# Security tests report
open reports/security_report.html
```

### Allure Reports

```bash
# Generate and view Allure report
allure serve allure-results

# Generate static Allure report
allure generate allure-results --clean -o allure-report
open allure-report/index.html
```

### RSpec Reports

```bash
# Run RSpec with HTML output
rspec --format html --out reports/rspec_report.html

# View report
open reports/rspec_report.html
```

## Available Tags in Project

### Test Type Tags
- `@ui` - UI/Mobile tests
- `@api` - API tests
- `@security` - Security tests
- `@mobile` - Mobile-specific tests

### Test Category Tags
- `@smoke` - Smoke tests (critical path)
- `@positive` - Positive test scenarios
- `@negative` - Negative test scenarios
- `@validation` - Input validation tests
- `@performance` - Performance tests

### Feature Tags
- `@login` - Login functionality
- `@products` - Product catalog
- `@cart` - Shopping cart
- `@checkout` - Checkout process
- `@authentication` - Authentication tests
- `@authorization` - Authorization tests
- `@session` - Session management
- `@data` - Data validation
- `@input_validation` - Input validation
- `@brute_force` - Brute force protection
- `@ssl` - SSL/TLS tests

### Platform Tags
- `@android` - Android-specific
- `@ios` - iOS-specific

## Examples

### Example 1: Run Smoke Tests on Android
```bash
PLATFORM=android cucumber --tags @smoke
```

### Example 2: Run All Positive UI Tests
```bash
cucumber --tags "@ui and @positive"
```

### Example 3: Run API and Security Tests
```bash
cucumber --tags "@api or @security"
```

### Example 4: Run Everything Except Negative Tests
```bash
cucumber --tags "not @negative"
```

### Example 5: Run Specific Feature with Smoke Tag
```bash
cucumber features/ui_login.feature --tags @smoke
```

### Example 6: Generate All Reports
```bash
# Run with default profile (generates all reports)
cucumber

# Then view reports
open reports/cucumber_report.html
allure serve allure-results
```

### Example 7: CI/CD Execution
```bash
# Run in CI mode (strict, with reports)
cucumber -p ci
```

## Tips

1. **Always use `bundle exec`** to ensure correct gem versions
2. **Create reports directory** before running tests: `mkdir -p reports`
3. **Use profiles** for consistent reporting across runs
4. **Combine tags** for precise test selection
5. **Run smoke tests first** for quick feedback
6. **Use parallel execution** for faster results
7. **Check HTML reports** for detailed test results
8. **Use Allure** for rich, interactive reports
