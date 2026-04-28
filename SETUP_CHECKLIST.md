# Setup Checklist - Fully Automated CI/CD

## ✅ Complete Setup in 30 Minutes

### Step 1: GitHub Secrets (10 minutes)

Go to **Settings → Secrets and variables → Actions** and add:

#### Email Notifications (Required)
```
EMAIL_USERNAME = your-email@gmail.com
EMAIL_PASSWORD = your-gmail-app-password
NOTIFICATION_EMAIL = team@company.com
```

**How to get Gmail App Password:**
1. Go to https://myaccount.google.com/security
2. Enable 2-Factor Authentication
3. Search for "App Passwords"
4. Select "Mail" and generate
5. Copy the 16-character password

#### Bitrise Integration (Required)
```
BITRISE_API_TOKEN = your-bitrise-personal-access-token
BITRISE_APP_SLUG = your-android-app-slug
BITRISE_IOS_APP_SLUG = your-ios-app-slug
```

**How to get Bitrise tokens:**
1. Go to https://app.bitrise.io
2. Click your profile → Account Settings
3. Security → Generate Personal Access Token
4. Copy the token
5. Go to your app → Settings → copy App Slug

#### Slack Notifications (Optional)
```
SLACK_WEBHOOK_URL = https://hooks.slack.com/services/xxx
```

#### Release Train (Optional - for production releases)
```
FIREBASE_TOKEN = your-firebase-ci-token
FIREBASE_ANDROID_APP_ID = 1:xxx:android:xxx
FIREBASE_IOS_APP_ID = 1:xxx:ios:xxx
BITRISEIO_SERVICE_ACCOUNT_JSON_KEY_URL = google-play-service-account
BITRISEIO_APP_STORE_CONNECT_API_KEY_URL = app-store-connect-key
APP_STORE_CONNECT_API_ISSUER = your-issuer-id
ANDROID_PACKAGE_NAME = com.yourcompany.app
```

### Step 2: Bitrise Setup (10 minutes)

1. **Sign up at Bitrise** (FREE)
   - Go to https://www.bitrise.io
   - Sign up with GitHub
   - Connect your repository

2. **Upload bitrise.yml**
   - In Bitrise dashboard → Workflow Editor
   - Switch to `bitrise.yml` tab
   - Paste contents of `bitrise.yml`
   - Save

3. **Configure Environment Variables**
   - Go to Workflow → Env Vars
   - Add:
     ```
     PROJECT_LOCATION = ./android
     BITRISE_PROJECT_PATH = ./ios/YourApp.xcworkspace
     BITRISE_SCHEME = YourApp
     ```

### Step 3: GitHub Settings (5 minutes)

1. **Enable Actions**
   - Settings → Actions → General
   - Allow all actions ✅

2. **Branch Protection (Optional)**
   - Settings → Branches → Add rule
   - Branch name: `master` or `main`
   - Require status checks: ✅
   - Require branches to be up to date: ✅

3. **Create Labels**
   - Issues → Labels → New label
   - Name: `auto-merge`
   - Color: Green
   - Description: "Auto-merge when all checks pass"

### Step 4: Test the Setup (5 minutes)

1. **Create a test PR**
   ```bash
   git checkout -b test/ci-setup
   echo "# Test" >> TEST.md
   git add TEST.md
   git commit -m "test: CI/CD setup"
   git push origin test/ci-setup
   gh pr create --title "Test CI/CD" --body "Testing automation"
   ```

2. **Watch the automation**
   - Go to Actions tab
   - See "PR Checks" workflow running
   - Check your email for notifications
   - View metrics in PR comments

3. **Test auto-merge (optional)**
   ```bash
   gh pr edit <PR_NUMBER> --add-label "auto-merge"
   # Wait for all checks to pass
   # PR will auto-merge
   ```

## 🎯 What You Get

### Automatic PR Workflow

```
PR Opened
    ↓
GitHub Actions (6-10 mins)
    ├─ Code Quality ✅
    ├─ Unit Tests ✅
    ├─ API Tests ✅
    └─ Security Tests ✅
    ↓
Bitrise Mobile Tests (15-20 mins)
    ├─ Android UI Test ✅
    └─ iOS UI Test ✅
    ↓
Metrics Posted to PR ✅
    ↓
Email Notification Sent ✅
    ↓
Auto-Merge (if labeled) ✅
    ↓
Release Train (if [release] tag) ✅
```

### Email Notifications

You'll receive emails for:
- ✅ All checks passed
- ❌ Some checks failed
- ✅ PR auto-merged
- 🚂 Release train started
- ❌ Any failure in pipeline

### PR Comments

Automatic comments with:
- 📊 Test metrics dashboard
- ✅ Pass/fail status
- ⏱️ Duration
- 📈 Coverage
- 🔗 Links to reports

## 🚀 Usage Guide

### Normal PR Flow (Fully Automatic)

```bash
# 1. Create feature branch
git checkout -b feature/new-feature

# 2. Make changes and commit
git add .
git commit -m "feat: add new feature"

# 3. Push and create PR
git push origin feature/new-feature
gh pr create

# 4. Everything else is AUTOMATIC:
#    - Tests run
#    - Metrics posted
#    - Email sent
#    - (Optional) Auto-merge if labeled
```

### Auto-Merge PR

```bash
# Add label to PR
gh pr edit <PR_NUMBER> --add-label "auto-merge"

# When all checks pass → Automatically merged
# Email notification sent
```

### Auto-Release

```bash
# Include [release] in commit message
git commit -m "feat: new feature [release]"
git push origin master

# When merged to master → Automatically triggers release train
# Email notification sent
# 12-hour release pipeline starts
```

### Hotfix Release

```bash
# Go to GitHub Actions → Release Train
# Click "Run workflow"
# Select:
#   Release Type: hotfix
#   Version: 1.0.1-hotfix
# Click "Run workflow"

# All stages execute immediately
# Email sent at each stage
```

## 📧 Email Notification Examples

### Success Email
```
Subject: ✅ PR #123 - All Checks Passed

PR #123: Add new login feature

✅ All checks passed successfully!

- Code Quality: ✅ Passed
- Unit Tests: ✅ Passed (52 tests, 2m 45s)
- API Tests: ✅ Passed (8 tests, 1m 12s)
- Security Tests: ✅ Passed (12 tests, 2m 01s)
- Mobile Tests: ✅ Passed (2 tests, 18m 34s)

PR is ready to merge.

View PR: https://github.com/...
```

### Failure Email
```
Subject: ❌ PR #123 - Checks Failed

PR #123: Add new login feature

❌ Some checks failed!

- Code Quality: ✅ Passed
- Unit Tests: ❌ Failed (2 failures)
- API Tests: ✅ Passed
- Security Tests: ✅ Passed
- Mobile Tests: ⏭️ Skipped

Please review and fix the issues.

View PR: https://github.com/...
View Logs: https://github.com/.../actions/runs/...
```

### Release Train Email
```
Subject: 🚂 Release Train Started - v1.0.0

Release Train has been automatically triggered!

Version: 1.0.0
Branch: master

Release Timeline:
- Now: Build Release ✅
- +2 hrs: Internal Testers
- +4 hrs: Friends & Family
- +8 hrs: Beta Testers
- +10 hrs: Submit for Review
- +12 hrs: Production Release

Track progress: https://github.com/.../actions
```

## 🔍 Monitoring & Metrics

### View Test Metrics

1. **In PR Comments**
   - Automatic dashboard posted
   - Shows all test results
   - Pass/fail status
   - Duration
   - Coverage

2. **In GitHub Actions**
   - Actions tab → Workflow run
   - View detailed logs
   - Download artifacts
   - See timing breakdown

3. **In Bitrise**
   - Bitrise dashboard
   - View mobile test logs
   - Download screenshots
   - See device logs

### Key Metrics Tracked

- ✅ Test pass rate
- ⏱️ Test duration
- 📊 Code coverage
- 🐛 Failure rate
- 📈 Trend over time

## 🎯 Optimization Tips

### 1. Use Caching (Already Configured)
```yaml
# Ruby gems cached automatically
bundler-cache: true

# Bitrise cache configured
cache-pull@2: {}
cache-push@2: {}
```

### 2. Parallel Execution (Already Configured)
```yaml
# Tests run in parallel
- Code Quality
- Unit Tests     } Parallel
- API Tests
```

### 3. Fast Feedback (Already Configured)
```yaml
# Fastest tests first
1. Code Quality (2 mins)
2. Unit Tests (3 mins)
3. API Tests (2 mins)
4. Mobile Tests (20 mins) - only if above pass
```

### 4. Conditional Execution (Already Configured)
```yaml
# Mobile tests only if code tests pass
mobile_tests:
  needs: [unit_tests, api_tests]
```

## 🚨 Troubleshooting

### Email Not Received

**Check:**
1. Gmail App Password is correct
2. 2FA is enabled on Gmail
3. Email address in secrets is correct
4. Check spam folder

**Fix:**
```bash
# Re-generate Gmail App Password
# Update GitHub secret EMAIL_PASSWORD
```

### Bitrise Not Triggered

**Check:**
1. BITRISE_API_TOKEN is correct
2. BITRISE_APP_SLUG is correct
3. Bitrise app is connected to repo

**Fix:**
```bash
# Get new API token from Bitrise
# Update GitHub secret
```

### Auto-Merge Not Working

**Check:**
1. PR has `auto-merge` label
2. All checks passed
3. Branch protection allows merge

**Fix:**
```bash
# Add label manually
gh pr edit <PR_NUMBER> --add-label "auto-merge"
```

### Tests Failing

**Check:**
1. View logs in Actions tab
2. Check Bitrise dashboard
3. Review error messages in email

**Fix:**
```bash
# Run tests locally
bundle exec rspec
bundle exec cucumber -p smoke

# Fix issues and push
git commit -m "fix: resolve test failures"
git push
```

## ✅ Verification Checklist

After setup, verify:

- [ ] GitHub secrets configured
- [ ] Bitrise connected and configured
- [ ] Test PR created
- [ ] PR checks workflow runs
- [ ] Email notification received
- [ ] Metrics posted to PR
- [ ] Bitrise tests triggered
- [ ] Auto-merge works (optional)
- [ ] Release train can be triggered (optional)

## 🎉 You're Done!

Your CI/CD is now **fully automated**:

✅ **No human intervention needed**
✅ **Email notifications on all events**
✅ **Metrics tracked and displayed**
✅ **Auto-merge when checks pass**
✅ **Auto-release when tagged**
✅ **$0/month cost (FREE tier)**

**Next Steps:**
1. Create your first real PR
2. Watch the automation work
3. Check your email
4. Review metrics in PR
5. Let it auto-merge (if labeled)

**Happy Automating! 🚀**
