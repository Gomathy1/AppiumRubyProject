# CI/CD Architecture - Optimal Setup

## 🎯 Recommended Architecture: GitHub Actions + Bitrise

### Why This Combination?

**GitHub Actions** (FREE unlimited for public repos, 2000 mins/month private):
- ✅ Fast for code quality checks
- ✅ Fast for unit tests
- ✅ Fast for API tests
- ✅ Excellent GitHub integration
- ✅ Easy PR automation
- ✅ Free for most use cases

**Bitrise** (FREE 200 builds/month):
- ✅ Specialized for mobile builds
- ✅ Pre-configured mobile emulators/simulators
- ✅ Android SDK & Xcode pre-installed
- ✅ Easy app signing and deployment
- ✅ Direct integration with App Store/Play Store

## 📊 Optimal Flow Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                        PULL REQUEST OPENED                           │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│                      GITHUB ACTIONS (Fast)                           │
├─────────────────────────────────────────────────────────────────────┤
│  Stage 1: Code Quality (1-2 mins)                                   │
│  • RuboCop linting                                                   │
│  • Code style checks                                                 │
│                                                                       │
│  Stage 2: Unit Tests (2-3 mins)                                     │
│  • RSpec unit tests                                                  │
│  • Generate coverage report                                          │
│                                                                       │
│  Stage 3: API Tests (1-2 mins)                                      │
│  • Cucumber API tests                                                │
│  • No emulator needed                                                │
│                                                                       │
│  Stage 4: Security Tests (2-3 mins)                                 │
│  • Security validation tests                                         │
│  • No emulator needed                                                │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
                    ✅ All GitHub Actions Pass
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│                      BITRISE (Mobile Tests)                          │
├─────────────────────────────────────────────────────────────────────┤
│  Stage 5: Mobile Tests (15-20 mins)                                 │
│  • Start Android Emulator                                            │
│  • Run 1 Android UI Test                                             │
│  • Start iOS Simulator                                               │
│  • Run 1 iOS UI Test                                                 │
│  • Generate mobile test reports                                      │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
                    ✅ All Bitrise Tests Pass
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│                      AUTO-MERGE PR                                   │
│  • Squash and merge to base branch                                   │
│  • Send email notification                                           │
│  • Post Slack notification                                           │
└─────────────────────────────────────────────────────────────────────┘
                                ↓
                    If merged to MASTER + [release] tag
                                ↓
┌─────────────────────────────────────────────────────────────────────┐
│                   AUTO-TRIGGER RELEASE TRAIN                         │
│  • Calculate next version                                            │
│  • Start release train workflow                                      │
│  • Send email notification                                           │
└─────────────────────────────────────────────────────────────────────┘
```

## 🚀 Complete Automation Flow

### 1. Developer Opens PR

```
Developer pushes code → PR opened
                          ↓
              GitHub Actions triggered automatically
```

### 2. GitHub Actions (6-10 minutes total)

**Parallel Execution:**
```
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│ Code Quality│  │ Unit Tests  │  │  API Tests  │
│   (2 mins)  │  │  (3 mins)   │  │  (2 mins)   │
└─────────────┘  └─────────────┘  └─────────────┘
        ↓                ↓                ↓
        └────────────────┴────────────────┘
                         ↓
                 All pass? → Trigger Bitrise
```

### 3. Bitrise Mobile Tests (15-20 minutes)

```
GitHub Actions → Trigger Bitrise via API
                        ↓
              Bitrise starts build
                        ↓
        ┌───────────────┴───────────────┐
        ↓                               ↓
  Android Tests                    iOS Tests
  (Emulator)                      (Simulator)
        ↓                               ↓
        └───────────────┬───────────────┘
                        ↓
              Report back to GitHub
```

### 4. Auto-Merge (if all pass)

```
All checks pass → Auto-merge enabled?
                        ↓
                      YES
                        ↓
              Merge PR automatically
                        ↓
              Send notifications
```

### 5. Auto-Release (if master + [release])

```
Merged to master → Contains [release] tag?
                        ↓
                      YES
                        ↓
              Calculate next version
                        ↓
              Trigger release train
                        ↓
              12-hour release pipeline
```

## 📧 Email Notifications (Automatic)

### When Emails Are Sent

1. **PR Checks Complete**
   - ✅ Success: "All checks passed, ready to merge"
   - ❌ Failure: "Some checks failed, please review"

2. **PR Auto-Merged**
   - ✅ "PR #X auto-merged successfully"

3. **Release Train Started**
   - 🚂 "Release train v1.0.0 started"

4. **Release Train Stage Complete**
   - 📦 "Deployed to Internal Testers"
   - 📦 "Deployed to Beta"
   - 🎉 "Released to Production"

5. **Any Failure in Pipeline**
   - ❌ "Build failed at stage X"
   - ❌ "Deployment failed"
   - ❌ "Tests failed"

## 📊 Metrics Dashboard (Automatic)

### PR Metrics (Posted as Comment)

```markdown
# 📊 PR Test Metrics Dashboard

## Summary
| Category       | Status | Duration | Pass Rate |
|----------------|--------|----------|-----------|
| Code Quality   | ✅     | 1m 23s   | 100%      |
| Unit Tests     | ✅     | 2m 45s   | 98%       |
| API Tests      | ✅     | 1m 12s   | 100%      |
| Security Tests | ✅     | 2m 01s   | 100%      |
| Mobile Tests   | ✅     | 18m 34s  | 100%      |

## Overall Status
✅ **All checks passed! Ready to merge.**

## Test Coverage
- **Total Tests Run**: 52
- **Platforms Tested**: Android, iOS
- **Test Types**: Unit, API, Security, UI
```

## 🔧 Setup Instructions

### Step 1: GitHub Secrets

Add these in **Settings → Secrets and variables → Actions**:

```yaml
# Email Notifications
EMAIL_USERNAME: your-email@gmail.com
EMAIL_PASSWORD: your-app-password  # Gmail App Password
NOTIFICATION_EMAIL: team@company.com

# Slack (Optional)
SLACK_WEBHOOK_URL: https://hooks.slack.com/services/xxx

# Bitrise
BITRISE_API_TOKEN: your-bitrise-api-token
BITRISE_APP_SLUG: your-android-app-slug
BITRISE_IOS_APP_SLUG: your-ios-app-slug

# For Release Train
FIREBASE_TOKEN: your-firebase-token
FIREBASE_ANDROID_APP_ID: 1:xxx:android:xxx
FIREBASE_IOS_APP_ID: 1:xxx:ios:xxx
BITRISEIO_SERVICE_ACCOUNT_JSON_KEY_URL: google-play-key
BITRISEIO_APP_STORE_CONNECT_API_KEY_URL: app-store-key
APP_STORE_CONNECT_API_ISSUER: your-issuer-id
ANDROID_PACKAGE_NAME: com.yourcompany.app
```

### Step 2: Gmail App Password

1. Go to Google Account → Security
2. Enable 2-Factor Authentication
3. Go to App Passwords
4. Generate password for "Mail"
5. Use this as `EMAIL_PASSWORD` secret

### Step 3: Enable Auto-Merge

Add label `auto-merge` to PR:
```bash
# Via GitHub UI: Add label "auto-merge"
# Or via CLI:
gh pr edit <PR_NUMBER> --add-label "auto-merge"
```

### Step 4: Enable Auto-Release

Include `[release]` in commit message:
```bash
git commit -m "feat: new feature [release]"
```

## 🎯 Optimization Strategies

### 1. Parallel Execution

```yaml
# GitHub Actions runs these in parallel:
- Code Quality (2 mins)
- Unit Tests (3 mins)     } Parallel = 3 mins total
- API Tests (2 mins)
```

### 2. Caching

```yaml
# Cache Ruby gems
- uses: ruby/setup-ruby@v1
  with:
    bundler-cache: true  # Saves 1-2 mins

# Cache Bitrise dependencies
- cache-pull@2: {}
- cache-push@2: {}       # Saves 2-3 mins
```

### 3. Conditional Execution

```yaml
# Only run mobile tests if code tests pass
mobile_tests:
  needs: [unit_tests, api_tests]  # Saves time on failures
```

### 4. Fast Feedback

```yaml
# Run fastest tests first
1. Code Quality (1-2 mins)  → Fast fail
2. Unit Tests (2-3 mins)    → Fast fail
3. API Tests (1-2 mins)     → Fast fail
4. Mobile Tests (15-20 mins) → Only if above pass
```

## 📈 Performance Metrics

### Expected Timings

| Stage | GitHub Actions | Bitrise | Total |
|-------|---------------|---------|-------|
| Code Quality | 1-2 mins | - | 1-2 mins |
| Unit Tests | 2-3 mins | - | 2-3 mins |
| API Tests | 1-2 mins | - | 1-2 mins |
| Security Tests | 2-3 mins | - | 2-3 mins |
| Mobile Tests | - | 15-20 mins | 15-20 mins |
| **Total** | **6-10 mins** | **15-20 mins** | **21-30 mins** |

### Cost Analysis (FREE Tier)

**GitHub Actions:**
- Public repos: Unlimited ✅
- Private repos: 2000 mins/month
- Usage per PR: ~10 mins
- **PRs per month: 200** ✅

**Bitrise:**
- Free tier: 200 builds/month
- Usage per PR: 1 build
- **PRs per month: 200** ✅

**Total Cost: $0/month** 🎉

## 🔄 Workflow Files

### Created Files

1. `.github/workflows/pr-checks.yml`
   - Runs on every PR
   - Code quality, unit, API, security tests
   - Triggers Bitrise mobile tests
   - Posts metrics to PR
   - Sends email notifications

2. `.github/workflows/auto-merge-and-release.yml`
   - Auto-merges PR when all checks pass
   - Auto-triggers release train on master merge
   - Calculates next version automatically

3. `.github/workflows/release-train.yml`
   - 6-stage release pipeline
   - Configurable time delays
   - Hotfix mode
   - Stop/Replace controls

4. `.github/workflows/stop-release-train.yml`
   - Stop running release

5. `.github/workflows/replace-release-train.yml`
   - Replace running release with new one

6. `.github/workflows/manual-deploy.yml`
   - Manual deployment control

## 🎬 Usage Examples

### Example 1: Normal PR Flow

```bash
# Developer creates PR
git checkout -b feature/new-feature
git commit -m "feat: add new feature"
git push origin feature/new-feature
gh pr create

# Automatic:
# 1. GitHub Actions runs (6-10 mins)
# 2. Bitrise runs mobile tests (15-20 mins)
# 3. Metrics posted to PR
# 4. Email sent: "All checks passed"
# 5. If label "auto-merge" → Auto-merged
```

### Example 2: Auto-Release Flow

```bash
# Developer merges to master with [release] tag
git checkout master
git merge feature/new-feature
git commit -m "feat: new feature [release]"
git push origin master

# Automatic:
# 1. Auto-merge-and-release workflow detects [release]
# 2. Calculates next version (e.g., 1.0.1)
# 3. Triggers release train
# 4. Email sent: "Release train started"
# 5. 12-hour release pipeline begins
```

### Example 3: Hotfix Flow

```bash
# Critical bug in production
git checkout -b hotfix/critical-bug
git commit -m "fix: critical bug [hotfix]"
git push origin hotfix/critical-bug

# Manual trigger in GitHub Actions:
# Release Train → Run workflow
# - Release Type: hotfix
# - Version: 1.0.2-hotfix

# Automatic:
# 1. All stages execute immediately
# 2. No time delays
# 3. Email sent at each stage
# 4. Production release in ~30 mins
```

## 🚨 Error Handling

### Automatic Error Notifications

**Email sent immediately on:**
- ❌ Code quality failure
- ❌ Unit test failure
- ❌ API test failure
- ❌ Mobile test failure
- ❌ Build failure
- ❌ Deployment failure

**Email includes:**
- Error details
- Failed stage
- Logs link
- Workflow run link
- PR link

### Automatic Retry Logic

```yaml
# Bitrise automatically retries on transient failures
- Wait for emulator (with timeout)
- Network requests (with retry)
- Build steps (configurable retry)
```

## ✅ Best Practices

1. **Use auto-merge label** for trusted PRs
2. **Include [release] tag** for automatic releases
3. **Use hotfix type** for emergencies
4. **Monitor email notifications** for failures
5. **Check metrics dashboard** in PR comments
6. **Review Bitrise logs** for mobile test details
7. **Use caching** to speed up builds
8. **Run fast tests first** for quick feedback

## 🎯 Summary

**Fully Automated:**
- ✅ PR checks run automatically
- ✅ Mobile tests triggered automatically
- ✅ Metrics posted automatically
- ✅ Emails sent automatically
- ✅ PR merged automatically (with label)
- ✅ Release triggered automatically (with tag)
- ✅ No human intervention needed

**Cost:**
- ✅ $0/month (FREE tier)
- ✅ 200 PRs/month supported
- ✅ Unlimited for open-source

**Performance:**
- ✅ 21-30 mins per PR
- ✅ Parallel execution
- ✅ Fast feedback (6-10 mins for code tests)
- ✅ Mobile tests only if code tests pass
