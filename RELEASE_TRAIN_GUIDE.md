# Release Train Guide

## Overview

This project includes a fully automated **Release Train** system that manages the entire release lifecycle from build to production deployment with configurable time delays between stages.

## Release Train Stages

### Standard Release Train Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                     RELEASE TRAIN TIMELINE                       │
├─────────────────────────────────────────────────────────────────┤
│ X hrs      │ Build Release from Master                           │
│ X + 2 hrs  │ Deploy to Internal Testers                         │
│ X + 4 hrs  │ Deploy to Friends & Family                         │
│ X + 8 hrs  │ Deploy to Beta Testers                             │
│ X + 10 hrs │ Submit for App Store/Play Store Review            │
│ X + 12 hrs │ Release to Production (App Store & Play Store)    │
└─────────────────────────────────────────────────────────────────┘
```

### Hotfix Flow (Immediate)

```
┌─────────────────────────────────────────────────────────────────┐
│                        HOTFIX TIMELINE                           │
├─────────────────────────────────────────────────────────────────┤
│ Immediate  │ Build → Internal → Beta → Review → Production     │
│            │ All stages execute without delays                  │
└─────────────────────────────────────────────────────────────────┘
```

## Starting a Release Train

### Option 1: Standard Release Train

1. Go to **GitHub Actions** tab
2. Click **"Release Train"** workflow
3. Click **"Run workflow"**
4. Fill in the parameters:
   - **Release Type**: `release_train`
   - **Version**: `1.0.0` (your version number)
   - **Skip to stage**: Leave empty (starts from beginning)
   - **Stop at stage**: Leave empty (runs all stages)
5. Click **"Run workflow"**

### Option 2: Hotfix Release

1. Go to **GitHub Actions** tab
2. Click **"Release Train"** workflow
3. Click **"Run workflow"**
4. Fill in the parameters:
   - **Release Type**: `hotfix`
   - **Version**: `1.0.1` (hotfix version)
5. Click **"Run workflow"**

All stages execute immediately without delays!

## Advanced Release Train Controls

### Skip to Specific Stage

Start the release train from a specific stage (useful for resuming):

```yaml
Release Type: release_train
Version: 1.0.0
Skip to stage: beta  # Options: internal, friends_family, beta, review, production
Stop at stage: (empty)
```

**Example Use Cases:**
- Internal testing already done → Skip to `friends_family`
- Need to re-run beta → Skip to `beta`
- Only want to submit for review → Skip to `review`

### Stop at Specific Stage

Run only up to a certain stage:

```yaml
Release Type: release_train
Version: 1.0.0
Skip to stage: (empty)
Stop at stage: beta  # Stops after beta deployment
```

**Example Use Cases:**
- Test internal deployment only → Stop at `internal`
- Don't auto-submit for review → Stop at `beta`
- Manual review before production → Stop at `review`

## Stopping a Release Train

If you need to stop a running release train:

1. Go to **GitHub Actions** tab
2. Find the running **"Release Train"** workflow
3. Note the **Run ID** (in the URL or workflow details)
4. Click **"Stop Release Train"** workflow
5. Click **"Run workflow"**
6. Fill in:
   - **Run ID**: `1234567890` (the run ID from step 3)
   - **Reason**: `Critical bug found in build`
7. Click **"Run workflow"**

The release train will be cancelled immediately.

## Replacing a Release Train

To stop current release and start a new one:

1. Go to **GitHub Actions** tab
2. Find the running **"Release Train"** workflow
3. Note the **Run ID**
4. Click **"Replace Release Train"** workflow
5. Click **"Run workflow"**
6. Fill in:
   - **Current Run ID**: `1234567890`
   - **New Version**: `1.0.1`
   - **Start from stage**: `internal` (where to start new release)
   - **Reason**: `Fixed critical bug, deploying new build`
7. Click **"Run workflow"**

This will:
- Stop the current release train
- Start a new release train with the new version
- Begin from the specified stage

## Test Execution in Release Train

### Tests Run During Build Stage

The release train runs **1 test from each category** on both platforms:

#### Android Tests (Emulator)
- ✅ 1 Unit Test: `appium_config_spec.rb`
- ✅ 1 API Test: `api_tests.feature:7`
- ✅ 1 Security Test: `security_tests.feature:7`
- ✅ 1 UI Test: `ui_login.feature:11`

#### iOS Tests (Simulator)
- ✅ 1 UI Test: `ui_login.feature:11`

### Bitrise Integration

The release train triggers Bitrise workflows:

**Android Build:**
```bash
Workflow: build_android_release
- Builds release APK
- Signs APK
- Deploys to Google Play Internal track
```

**iOS Build:**
```bash
Workflow: build_ios_release
- Builds release IPA
- Signs with App Store certificate
- Uploads to App Store Connect
```

## Deployment Stages Explained

### Stage 1: Internal Testers (X + 2 hours)
**Platforms:**
- Firebase App Distribution (Android & iOS)
- Google Play Internal Testing (Android)

**Who gets it:**
- Internal QA team
- Development team

**Purpose:**
- Smoke testing
- Quick validation

### Stage 2: Friends & Family (X + 4 hours)
**Platforms:**
- TestFlight (iOS)
- Google Play Internal Testing (Android)

**Who gets it:**
- Trusted users
- Company employees
- Close partners

**Purpose:**
- Real-world usage testing
- Feedback collection

### Stage 3: Beta Testers (X + 8 hours)
**Platforms:**
- TestFlight External Testing (iOS)
- Google Play Beta (Android)

**Who gets it:**
- Public beta testers
- Early adopters

**Purpose:**
- Wide testing
- Performance validation
- Bug discovery

### Stage 4: Submit for Review (X + 10 hours)
**Actions:**
- Submit to App Store Review (iOS)
- Submit to Google Play Review (Android)

**Purpose:**
- Platform compliance review
- Final approval before production

### Stage 5: Production Release (X + 12 hours)
**Actions:**
- Release to App Store
- Release to Google Play Store
- Create GitHub Release

**Purpose:**
- Public availability
- Full rollout

## Configuration

### GitHub Secrets Required

Add these secrets in **Settings → Secrets and variables → Actions**:

```yaml
# Bitrise
BITRISE_API_TOKEN: your_bitrise_api_token
BITRISE_APP_SLUG: your_android_app_slug
BITRISE_IOS_APP_SLUG: your_ios_app_slug

# Firebase
FIREBASE_TOKEN: your_firebase_token
FIREBASE_ANDROID_APP_ID: your_android_app_id
FIREBASE_IOS_APP_ID: your_ios_app_id

# Google Play
BITRISEIO_SERVICE_ACCOUNT_JSON_KEY_URL: google_play_service_account_json

# App Store
BITRISEIO_APP_STORE_CONNECT_API_KEY_URL: app_store_connect_api_key
APP_STORE_CONNECT_API_ISSUER: your_issuer_id

# Android Signing
BITRISEIO_ANDROID_KEYSTORE_URL: keystore_url
BITRISEIO_ANDROID_KEYSTORE_PASSWORD: keystore_password
BITRISEIO_ANDROID_KEYSTORE_ALIAS: key_alias
BITRISEIO_ANDROID_KEYSTORE_PRIVATE_KEY_PASSWORD: key_password

# Package Names
ANDROID_PACKAGE_NAME: com.yourcompany.app
```

### Bitrise Environment Variables

Set these in Bitrise dashboard:

```yaml
VERSION: (set dynamically by workflow)
PROJECT_LOCATION: ./android
BITRISE_PROJECT_PATH: ./ios/YourApp.xcworkspace
BITRISE_SCHEME: YourApp
```

## Customizing Time Delays

To change the time delays between stages, edit `.github/workflows/release-train.yml`:

```yaml
# Current delays
deploy_internal:
  - name: Wait for scheduled time (2 hours)
    run: sleep 7200  # 2 hours = 7200 seconds

deploy_friends_family:
  - name: Wait for scheduled time (2 hours after internal)
    run: sleep 7200  # Change this value

deploy_beta:
  - name: Wait for scheduled time (4 hours after friends & family)
    run: sleep 14400  # 4 hours = 14400 seconds
```

**Common time values:**
- 1 hour = 3600 seconds
- 2 hours = 7200 seconds
- 4 hours = 14400 seconds
- 8 hours = 28800 seconds
- 12 hours = 43200 seconds
- 24 hours = 86400 seconds

## Monitoring Release Train

### View Progress

1. Go to **GitHub Actions** tab
2. Click on the running **"Release Train"** workflow
3. View the workflow visualization showing:
   - ✅ Completed stages (green)
   - ⏳ Running stages (yellow)
   - ⏸️ Waiting stages (gray)
   - ❌ Failed stages (red)

### Notifications

Set up notifications in the workflow files:

```yaml
- name: Notify Team
  run: |
    # Add Slack webhook
    curl -X POST $SLACK_WEBHOOK_URL \
      -H 'Content-Type: application/json' \
      -d '{"text":"Stage completed: Internal Testing"}'
    
    # Or send email
    # Add email notification script
```

## Best Practices

### 1. Version Naming
- **Major releases**: `1.0.0`, `2.0.0`
- **Minor releases**: `1.1.0`, `1.2.0`
- **Patches**: `1.0.1`, `1.0.2`
- **Hotfixes**: `1.0.1-hotfix`, `1.0.2-hotfix`

### 2. When to Use Hotfix
- Critical bugs in production
- Security vulnerabilities
- App crashes
- Data loss issues

### 3. When to Stop Release Train
- Critical bug discovered
- Failed tests in production
- Compliance issues
- Need to add urgent fix

### 4. When to Replace Release Train
- Bug fixed, new build ready
- Feature needs to be added
- Version needs update

### 5. Testing Before Release
Always run full test suite before starting release train:
```bash
# Run all tests
bundle exec rake full_suite

# Or run specific categories
bundle exec cucumber -p smoke
bundle exec cucumber -p api
bundle exec cucumber -p security
```

## Troubleshooting

### Release Train Stuck
**Problem:** Workflow is waiting but not progressing

**Solution:**
1. Check workflow logs
2. Verify time delays are correct
3. Check if previous stage completed successfully

### Build Failed
**Problem:** Bitrise build failed

**Solution:**
1. Check Bitrise dashboard for error logs
2. Verify all secrets are configured
3. Check signing certificates are valid
4. Re-run the build workflow

### Deployment Failed
**Problem:** Deployment to store failed

**Solution:**
1. Verify API keys are valid
2. Check store console for errors
3. Ensure app version is incremented
4. Verify app meets store guidelines

### Cannot Stop Release Train
**Problem:** Stop workflow not working

**Solution:**
1. Manually cancel in GitHub Actions UI
2. Click on the running workflow
3. Click "Cancel workflow" button

## Examples

### Example 1: Standard Release
```yaml
Release Type: release_train
Version: 2.0.0
Skip to stage: (empty)
Stop at stage: (empty)
```
Result: Full release train, all stages, 12-hour timeline

### Example 2: Beta Testing Only
```yaml
Release Type: release_train
Version: 2.0.0
Skip to stage: (empty)
Stop at stage: beta
```
Result: Stops after beta deployment, no production release

### Example 3: Resume from Beta
```yaml
Release Type: release_train
Version: 2.0.0
Skip to stage: beta
Stop at stage: (empty)
```
Result: Skips internal and friends/family, starts from beta

### Example 4: Emergency Hotfix
```yaml
Release Type: hotfix
Version: 1.0.1-hotfix
```
Result: Immediate deployment through all stages

### Example 5: Replace Running Release
```yaml
Current Run ID: 1234567890
New Version: 2.0.1
Start from stage: internal
Reason: Fixed critical login bug
```
Result: Stops old release, starts new one from internal stage

## Support

For issues or questions:
1. Check workflow logs in GitHub Actions
2. Check Bitrise build logs
3. Review this guide
4. Contact DevOps team
