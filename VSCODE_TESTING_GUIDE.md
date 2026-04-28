# Testing iOS and Android Appium Tests in VS Code

## Prerequisites

### 1. Install Required Software

#### For macOS (You have this):

```bash
# Install Homebrew (if not already installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Node.js (for Appium)
brew install node

# Install Appium
npm install -g appium

# Install Appium drivers
appium driver install uiautomator2  # For Android
appium driver install xcuitest       # For iOS

# Install Java (for Android)
brew install openjdk@11
```

### 2. Set Up Android Environment

```bash
# Install Android Studio
# Download from: https://developer.android.com/studio

# After installation, open Android Studio:
# 1. Go to Settings → SDK Manager
# 2. Install Android SDK (API 30 or higher)
# 3. Install Android SDK Build-Tools
# 4. Install Android Emulator

# Set environment variables (add to ~/.zshrc)
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# Reload shell
source ~/.zshrc

# Verify installation
adb --version
```

### 3. Set Up iOS Environment (macOS only)

```bash
# Install Xcode from App Store
# Open Xcode and install additional components

# Install Xcode Command Line Tools
xcode-select --install

# Install Carthage (for iOS dependencies)
brew install carthage

# Verify installation
xcrun simctl list devices
```

## Quick Test Setup (Without Mobile Apps)

Since you don't have actual mobile apps yet, let's test with **demo apps**:

### Option 1: Use Demo Apps (Recommended for Learning)

```bash
cd /Users/gomathy/eclipse-workspace/AppiumRubyProject

# Download Android demo app
mkdir -p apps
curl -L https://github.com/appium/appium/raw/master/packages/appium/sample-code/apps/ApiDemos-debug.apk -o apps/ApiDemos-debug.apk

# Download iOS demo app (macOS only)
curl -L https://github.com/appium/appium/raw/master/packages/appium/sample-code/apps/TestApp.app.zip -o apps/TestApp.app.zip
cd apps && unzip TestApp.app.zip && cd ..
```

### Option 2: Update .env File

Update your `.env` file with demo app paths:

```bash
# Android Configuration
PLATFORM=android
ANDROID_DEVICE_NAME=Pixel_6_API_30
ANDROID_PLATFORM_VERSION=11.0
ANDROID_APP_PATH=/Users/gomathy/eclipse-workspace/AppiumRubyProject/apps/ApiDemos-debug.apk

# iOS Configuration  
IOS_DEVICE_NAME=iPhone 14
IOS_PLATFORM_VERSION=16.0
IOS_APP_PATH=/Users/gomathy/eclipse-workspace/AppiumRubyProject/apps/TestApp.app

# Appium Server
APPIUM_SERVER_URL=http://127.0.0.1:4723
```

## Step-by-Step Testing in VS Code

### Step 1: Start Appium Server

Open VS Code Terminal (`` Ctrl+` ``):

```bash
# Start Appium server
appium

# You should see:
# [Appium] Welcome to Appium v2.x.x
# [Appium] Appium REST http interface listener started on 0.0.0.0:4723
```

Keep this terminal running!

### Step 2: Start Android Emulator (New Terminal)

Open new terminal in VS Code (`` Ctrl+Shift+` ``):

```bash
# List available emulators
emulator -list-avds

# If no emulators, create one:
# Open Android Studio → Device Manager → Create Device
# Or use command line:
avdmanager create avd -n Pixel_6_API_30 -k "system-images;android-30;google_apis;arm64-v8a"

# Start emulator
emulator -avd Pixel_6_API_30

# Or use Android Studio: Device Manager → Play button
```

Wait for emulator to fully boot (2-3 minutes).

### Step 3: Run Android Tests (New Terminal)

Open another new terminal:

```bash
cd /Users/gomathy/eclipse-workspace/AppiumRubyProject

# Set platform to Android
export PLATFORM=android

# Run a single test (without Ruby issues - use Docker)
docker run --rm -v $(pwd):/app -w /app ruby:3.0 bash -c "bundle install && bundle exec cucumber features/ui_login.feature:11"

# Or if you fix Ruby locally:
bundle exec cucumber features/ui_login.feature:11
```

### Step 4: Start iOS Simulator (macOS only)

```bash
# List available simulators
xcrun simctl list devices

# Boot a simulator
xcrun simctl boot "iPhone 14"

# Or open Simulator app
open -a Simulator
```

### Step 5: Run iOS Tests

```bash
# Set platform to iOS
export PLATFORM=ios

# Run test
docker run --rm -v $(pwd):/app -w /app ruby:3.0 bash -c "bundle install && PLATFORM=ios bundle exec cucumber features/ui_login.feature:11"
```

## VS Code Configuration for Easy Testing

### Create VS Code Tasks

Create `.vscode/tasks.json`:

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Start Appium Server",
      "type": "shell",
      "command": "appium",
      "isBackground": true,
      "problemMatcher": []
    },
    {
      "label": "Start Android Emulator",
      "type": "shell",
      "command": "emulator -avd Pixel_6_API_30",
      "isBackground": true,
      "problemMatcher": []
    },
    {
      "label": "Run Android Tests",
      "type": "shell",
      "command": "PLATFORM=android bundle exec cucumber -p ui",
      "group": "test",
      "problemMatcher": []
    },
    {
      "label": "Run iOS Tests",
      "type": "shell",
      "command": "PLATFORM=ios bundle exec cucumber -p ui",
      "group": "test",
      "problemMatcher": []
    },
    {
      "label": "Run Unit Tests",
      "type": "shell",
      "command": "bundle exec rspec spec/unit",
      "group": "test",
      "problemMatcher": []
    },
    {
      "label": "Run API Tests",
      "type": "shell",
      "command": "bundle exec cucumber -p api",
      "group": "test",
      "problemMatcher": []
    }
  ]
}
```

### Create VS Code Launch Configuration

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Debug Cucumber Tests",
      "type": "Ruby",
      "request": "launch",
      "program": "${workspaceRoot}/bin/cucumber",
      "args": ["${file}"]
    },
    {
      "name": "Debug RSpec Tests",
      "type": "Ruby",
      "request": "launch",
      "program": "${workspaceRoot}/bin/rspec",
      "args": ["${file}"]
    }
  ]
}
```

## Easiest Way: Use Docker (Recommended)

Since you have Ruby version issues, use Docker:

### Create docker-compose-test.yml

```yaml
version: '3.8'

services:
  tests:
    image: ruby:3.0
    volumes:
      - .:/app
    working_dir: /app
    command: bash -c "bundle install && bundle exec rspec spec/unit"
    
  api-tests:
    image: ruby:3.0
    volumes:
      - .:/app
    working_dir: /app
    command: bash -c "bundle install && bundle exec cucumber -p api"
```

### Run Tests with Docker

```bash
# Run unit tests
docker-compose -f docker-compose-test.yml run tests

# Run API tests
docker-compose -f docker-compose-test.yml run api-tests

# Run specific test
docker-compose -f docker-compose-test.yml run tests bash -c "bundle install && bundle exec cucumber features/api_tests.feature:7"
```

## What You Can Test Right Now (No Mobile Setup)

### 1. Unit Tests (No Emulator Needed)

```bash
# Using Docker
docker run --rm -v $(pwd):/app -w /app ruby:3.0 bash -c "bundle install && bundle exec rspec spec/unit"

# Expected output:
# ✅ appium_config_spec.rb - 8 examples, 0 failures
# ✅ base_page_spec.rb - 10 examples, 0 failures
# ✅ login_page_spec.rb - 12 examples, 0 failures
```

### 2. API Tests (No Emulator Needed)

```bash
# Using Docker
docker run --rm -v $(pwd):/app -w /app ruby:3.0 bash -c "bundle install && bundle exec cucumber -p api"

# Expected output:
# ✅ 8 scenarios (8 passed)
# ✅ Report: reports/api_report.html
```

### 3. Security Tests (No Emulator Needed)

```bash
docker run --rm -v $(pwd):/app -w /app ruby:3.0 bash -c "bundle install && bundle exec cucumber -p security"
```

## Recommended Testing Path

### For Learning (Without Mobile Apps):

1. **Test Unit Tests** ✅ (Works now with Docker)
   ```bash
   docker run --rm -v $(pwd):/app -w /app ruby:3.0 bash -c "bundle install && bundle exec rspec spec/unit --format documentation"
   ```

2. **Test API Tests** ✅ (Works now with Docker)
   ```bash
   docker run --rm -v $(pwd):/app -w /app ruby:3.0 bash -c "bundle install && bundle exec cucumber -p api"
   ```

3. **View Reports** ✅
   ```bash
   open reports/api_report.html
   ```

4. **Set up CI/CD** ✅ (Already done on GitHub)
   - Push code to GitHub
   - Tests run automatically
   - No local setup needed!

### For Full Mobile Testing:

1. Install Android Studio
2. Create Android emulator
3. Download demo app
4. Update .env file
5. Start Appium server
6. Start emulator
7. Run tests

## Quick Commands Reference

```bash
# Start Appium (Terminal 1)
appium

# Start Android Emulator (Terminal 2)
emulator -avd Pixel_6_API_30

# Run Android Tests (Terminal 3)
PLATFORM=android bundle exec cucumber features/ui_login.feature:11

# Start iOS Simulator (Terminal 2)
open -a Simulator

# Run iOS Tests (Terminal 3)
PLATFORM=ios bundle exec cucumber features/ui_login.feature:11

# Run Unit Tests (No emulator needed)
docker run --rm -v $(pwd):/app -w /app ruby:3.0 bash -c "bundle install && bundle exec rspec spec/unit"

# Run API Tests (No emulator needed)
docker run --rm -v $(pwd):/app -w /app ruby:3.0 bash -c "bundle install && bundle exec cucumber -p api"

# View Reports
open reports/cucumber_report.html
```

## Summary

**Can test NOW (no mobile setup):**
- ✅ Unit tests (Docker)
- ✅ API tests (Docker)
- ✅ Security tests (Docker)
- ✅ CI/CD on GitHub

**Need mobile setup for:**
- ❌ iOS UI tests (need Xcode + Simulator + iOS app)
- ❌ Android UI tests (need Android Studio + Emulator + Android app)

**Recommendation:** Test unit/API tests now with Docker, set up mobile environment later when you have actual mobile apps to test!
