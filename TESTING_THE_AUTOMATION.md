# Testing Your Automated CI/CD Setup

## 🧪 Complete Testing Guide

This guide shows you how to test every part of your automated CI/CD pipeline.

## Prerequisites Checklist

Before testing, ensure you have:

- [ ] Ruby 3.0+ installed
- [ ] Bundler installed (`gem install bundler`)
- [ ] Git installed
- [ ] GitHub CLI installed (optional: `brew install gh`)
- [ ] GitHub account with repository access
- [ ] Bitrise account (FREE signup at bitrise.io)

## Phase 1: Test Locally (10 minutes)

### Step 1: Install Dependencies

```bash
cd /Users/gomathy/eclipse-workspace/AppiumRubyProject

# Install Ruby gems
bundle install

# Verify installation
bundle exec cucumber --version
bundle exec rspec --version
```

**Expected output:**
```
Cucumber 9.x.x
RSpec 3.x.x
```

### Step 2: Run Unit Tests

```bash
# Run all unit tests
bundle exec rspec spec/unit --format documentation

# Expected: All tests should pass
# ✅ appium_config_spec.rb - 8 examples, 0 failures
# ✅ base_page_spec.rb - 10 examples, 0 failures
# ✅ login_page_spec.rb - 12 examples, 0 failures
# ✅ api_helper_spec.rb - 8 examples, 0 failures
# ✅ test_data_manager_spec.rb - 10 examples, 0 failures
```

### Step 3: Run API Tests

```bash
# Run API tests (no emulator needed)
bundle exec cucumber -p api

# Expected: All scenarios should pass
# ✅ 8 scenarios (8 passed)
# ✅ Report generated: reports/api_report.html
```

### Step 4: View Reports

```bash
# Open HTML report
open reports/api_report.html

# Or view in browser
# File → Open → reports/api_report.html
```

**✅ Phase 1 Complete!** Local tests work.

---

## Phase 2: Test GitHub Actions (30 minutes)

### Step 1: Set Up GitHub Secrets

Go to your GitHub repository:
1. Click **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add these secrets:

```yaml
# Required for email notifications
EMAIL_USERNAME = your-email@gmail.com
EMAIL_PASSWORD = your-gmail-app-password
NOTIFICATION_EMAIL = your-email@gmail.com

# Required for Bitrise integration
BITRISE_API_TOKEN = your-bitrise-token
BITRISE_APP_SLUG = your-app-slug
BITRISE_IOS_APP_SLUG = your-ios-app-slug
```

**How to get Gmail App Password:**
```
1. Go to https://myaccount.google.com/security
2. Enable 2-Factor Authentication
3. Search "App Passwords"
4. Select "Mail" → Generate
5. Copy the 16-character password
```

**How to get Bitrise tokens:**
```
1. Go to https://app.bitrise.io
2. Sign up (FREE)
3. Profile → Account Settings → Security
4. Generate Personal Access Token
5. Copy the token
```

### Step 2: Create Test Branch

```bash
# Create test branch
git checkout -b test/ci-automation

# Make a small change
echo "# CI/CD Test" >> TEST_CI.md
git add TEST_CI.md
git commit -m "test: CI/CD automation setup"

# Push to GitHub
git push origin test/ci-automation
```

### Step 3: Create Pull Request

```bash
# Using GitHub CLI
gh pr create --title "Test: CI/CD Automation" --body "Testing automated CI/CD pipeline"

# Or manually:
# 1. Go to GitHub repository
# 2. Click "Pull requests" → "New pull request"
# 3. Select test/ci-automation branch
# 4. Click "Create pull request"
```

### Step 4: Watch Automation Run

1. Go to **Actions** tab in GitHub
2. You should see "PR Checks" workflow running
3. Watch the stages:
   - ✅ Code Quality (1-2 mins)
   - ✅ Unit Tests (2-3 mins)
   - ✅ API Tests (1-2 mins)
   - ✅ Security Tests (2-3 mins)
   - ⏳ Mobile Tests (will fail without Bitrise setup)

### Step 5: Check Email

You should receive an email:
```
Subject: ✅ PR #X - All Checks Passed (or ❌ Some Checks Failed)

Details of test results...
```

### Step 6: Check PR Comments

Go to your PR and check for automatic comments:
- 🧪 Unit Test Results
- 🌐 API Test Results
- 📊 Metrics Dashboard

**✅ Phase 2 Complete!** GitHub Actions work.

---

## Phase 3: Test Bitrise Integration (20 minutes)

### Step 1: Set Up Bitrise

1. **Sign up at Bitrise** (FREE)
   ```
   Go to: https://www.bitrise.io
   Click: Sign up with GitHub
   ```

2. **Add Your App**
   ```
   Click: Add new app
   Select: Your repository
   Choose: Branch (main/master)
   ```

3. **Upload bitrise.yml**
   ```
   Workflow Editor → bitrise.yml tab
   Copy contents from: bitrise.yml
   Paste and Save
   ```

4. **Get App Slug**
   ```
   Settings → Copy "App Slug"
   Example: 1a2b3c4d5e6f7g8h
   ```

5. **Get API Token**
   ```
   Profile → Account Settings → Security
   Generate Personal Access Token
   Copy token
   ```

6. **Update GitHub Secrets**
   ```
   Add/Update:
   BITRISE_API_TOKEN = your-token
   BITRISE_APP_SLUG = your-app-slug
   ```

### Step 2: Test Bitrise Manually

1. Go to Bitrise dashboard
2. Click **Start/Schedule a Build**
3. Select workflow: `primary`
4. Branch: `test/ci-automation`
5. Click **Start Build**

Watch the build:
- ✅ Install dependencies
- ✅ Start Appium
- ✅ Create Android emulator
- ✅ Run 1 unit test
- ✅ Run 1 API test
- ✅ Run 1 security test
- ✅ Run 1 Android UI test
- ✅ Run 1 iOS UI test

**Expected duration:** 15-20 minutes

### Step 3: Test GitHub → Bitrise Integration

1. Make another change to your test PR:
   ```bash
   echo "# Test 2" >> TEST_CI.md
   git add TEST_CI.md
   git commit -m "test: trigger Bitrise from GitHub"
   git push origin test/ci-automation
   ```

2. Watch GitHub Actions trigger Bitrise automatically
3. Check Bitrise dashboard for new build
4. Wait for completion
5. Check PR comment for Bitrise results

**✅ Phase 3 Complete!** Bitrise integration works.

---

## Phase 4: Test Auto-Merge (10 minutes)

### Step 1: Enable Auto-Merge

```bash
# Get your PR number (e.g., #1)
gh pr list

# Add auto-merge label
gh pr edit 1 --add-label "auto-merge"

# Or manually:
# 1. Go to PR on GitHub
# 2. Click "Labels" on right side
# 3. Create/select "auto-merge" label
```

### Step 2: Wait for Checks

Wait for all checks to pass (21-30 minutes total)

### Step 3: Watch Auto-Merge

When all checks pass:
- ✅ PR automatically merges
- ✅ Email notification sent
- ✅ PR closed

**Check email for:**
```
Subject: ✅ PR #X Auto-Merged

PR #X has been automatically merged!
All checks passed successfully.
```

**✅ Phase 4 Complete!** Auto-merge works.

---

## Phase 5: Test Auto-Release (15 minutes)

### Step 1: Create Release Branch

```bash
# Create feature branch
git checkout master
git pull origin master
git checkout -b feature/test-release

# Make a change
echo "# Release Test" >> RELEASE_TEST.md
git add RELEASE_TEST.md

# Commit with [release] tag
git commit -m "feat: test release automation [release]"

# Push and create PR
git push origin feature/test-release
gh pr create --title "Test: Auto-Release" --body "Testing auto-release"
```

### Step 2: Add Auto-Merge Label

```bash
gh pr edit <PR_NUMBER> --add-label "auto-merge"
```

### Step 3: Wait for Auto-Merge

Wait for all checks to pass and PR to auto-merge.

### Step 4: Watch Release Train Start

1. Go to **Actions** tab
2. Look for "Release Train" workflow starting
3. Check email for:
   ```
   Subject: 🚂 Release Train Started - v1.0.0
   
   Release Timeline:
   - Now: Build Release
   - +2 hrs: Internal Testers
   - +4 hrs: Friends & Family
   ...
   ```

### Step 5: Stop Release Train (Test)

```bash
# Get the run ID from GitHub Actions
# Example: 1234567890

# Go to GitHub Actions → Stop Release Train → Run workflow
# Enter Run ID and reason
```

**✅ Phase 5 Complete!** Auto-release works.

---

## Phase 6: Test Hotfix Flow (10 minutes)

### Step 1: Trigger Hotfix

1. Go to **Actions** tab
2. Click **Release Train** workflow
3. Click **Run workflow**
4. Fill in:
   ```
   Release Type: hotfix
   Version: 1.0.1-hotfix
   ```
5. Click **Run workflow**

### Step 2: Watch Hotfix Execute

All stages should execute immediately (no delays):
- ✅ Build & Test
- ✅ Deploy to Internal
- ✅ Deploy to Beta
- ✅ Submit for Review
- ✅ Release to Production

**Expected duration:** ~30 minutes (no time delays)

### Step 3: Check Emails

You should receive multiple emails:
- 🚨 Hotfix started
- ✅ Each stage completed
- 🎉 Hotfix released

**✅ Phase 6 Complete!** Hotfix flow works.

---

## Phase 7: Test Error Handling (5 minutes)

### Step 1: Create Failing Test

```bash
# Create branch with failing test
git checkout -b test/failing-tests

# Add a file that will fail RuboCop
cat > bad_code.rb << 'EOF'
def bad_method
x=1+2
end
EOF

git add bad_code.rb
git commit -m "test: failing code quality"
git push origin test/failing-tests
gh pr create --title "Test: Failing Checks" --body "Testing error handling"
```

### Step 2: Watch Failure

1. Go to **Actions** tab
2. Watch "PR Checks" fail at Code Quality stage
3. Check email for failure notification:
   ```
   Subject: ❌ PR #X - Checks Failed
   
   Some checks failed:
   - Code Quality: ❌ Failed
   
   View logs: [link]
   ```

### Step 3: Check PR Comment

PR should have comment showing:
- ❌ Code Quality: Failed
- ⏭️ Other tests: Skipped

### Step 4: Clean Up

```bash
# Close the PR
gh pr close <PR_NUMBER>

# Delete branch
git checkout master
git branch -D test/failing-tests
git push origin --delete test/failing-tests
```

**✅ Phase 7 Complete!** Error handling works.

---

## Quick Test Commands

### Test Individual Components

```bash
# Test RuboCop
bundle exec rubocop

# Test Unit Tests
bundle exec rspec spec/unit

# Test API Tests
bundle exec cucumber -p api

# Test Security Tests
bundle exec cucumber -p security

# Test Smoke Tests
bundle exec cucumber -p smoke

# Test with specific tag
bundle exec cucumber --tags @smoke

# Test specific feature
bundle exec cucumber features/api_tests.feature

# Test specific scenario
bundle exec cucumber features/api_tests.feature:7
```

### Test Reports Generation

```bash
# Run tests and generate reports
bundle exec cucumber

# Check reports generated
ls -la reports/
# Should see:
# - cucumber_report.html
# - cucumber.json
# - allure-results/

# Open HTML report
open reports/cucumber_report.html

# Generate Allure report
allure serve allure-results
```

### Test Rake Tasks

```bash
# Test individual rake tasks
rake rubocop
rake unit_tests
rake api_tests
rake smoke
rake clean
rake full_suite
```

---

## Verification Checklist

After completing all phases, verify:

### Local Testing
- [ ] Dependencies installed successfully
- [ ] Unit tests pass
- [ ] API tests pass
- [ ] Reports generated
- [ ] Can view HTML reports

### GitHub Actions
- [ ] Secrets configured
- [ ] PR checks workflow runs
- [ ] All stages execute
- [ ] Email notifications received
- [ ] PR comments posted with metrics

### Bitrise Integration
- [ ] Bitrise account created
- [ ] App connected
- [ ] bitrise.yml uploaded
- [ ] Manual build works
- [ ] GitHub triggers Bitrise
- [ ] Mobile tests execute

### Auto-Merge
- [ ] Label created
- [ ] PR with label auto-merges
- [ ] Email notification sent

### Auto-Release
- [ ] [release] tag triggers release
- [ ] Release train starts
- [ ] Email notifications sent
- [ ] Can stop release train
- [ ] Can replace release train

### Hotfix
- [ ] Hotfix workflow runs
- [ ] All stages execute immediately
- [ ] No time delays
- [ ] Email notifications sent

### Error Handling
- [ ] Failing tests detected
- [ ] Email sent on failure
- [ ] PR comment shows failure
- [ ] Logs accessible

---

## Troubleshooting

### Issue: Email Not Received

**Check:**
```bash
# Verify secrets are set
# GitHub → Settings → Secrets → Actions
# Should see: EMAIL_USERNAME, EMAIL_PASSWORD, NOTIFICATION_EMAIL
```

**Fix:**
1. Re-generate Gmail App Password
2. Update GitHub secret
3. Test again

### Issue: Bitrise Not Triggered

**Check:**
```bash
# Verify secrets
# Should see: BITRISE_API_TOKEN, BITRISE_APP_SLUG
```

**Fix:**
1. Get new API token from Bitrise
2. Update GitHub secret
3. Verify App Slug is correct

### Issue: Tests Failing Locally

**Check:**
```bash
# Verify Ruby version
ruby --version  # Should be 3.0+

# Reinstall dependencies
rm -rf vendor/bundle
bundle install
```

### Issue: Auto-Merge Not Working

**Check:**
1. PR has "auto-merge" label
2. All checks passed
3. Branch protection allows merge

**Fix:**
```bash
# Manually add label
gh pr edit <PR_NUMBER> --add-label "auto-merge"
```

### Issue: GitHub Actions Not Running

**Check:**
1. Workflows are in `.github/workflows/`
2. Actions are enabled in Settings
3. Branch has push access

**Fix:**
```bash
# Re-push to trigger
git commit --allow-empty -m "trigger: CI"
git push
```

---

## Performance Benchmarks

After testing, you should see these timings:

| Component | Expected Time |
|-----------|--------------|
| Local Unit Tests | 10-30 seconds |
| Local API Tests | 30-60 seconds |
| GitHub Actions (Code Quality) | 1-2 minutes |
| GitHub Actions (Unit Tests) | 2-3 minutes |
| GitHub Actions (API Tests) | 1-2 minutes |
| Bitrise (Mobile Tests) | 15-20 minutes |
| **Total PR Checks** | **21-30 minutes** |
| Auto-Merge | Instant (after checks) |
| Release Train (Full) | 12 hours |
| Hotfix | 30 minutes |

---

## Success Criteria

Your setup is working correctly if:

✅ **Local tests run and pass**
✅ **GitHub Actions trigger on PR**
✅ **Email notifications received**
✅ **Metrics posted to PR**
✅ **Bitrise triggered from GitHub**
✅ **Mobile tests execute**
✅ **Auto-merge works (with label)**
✅ **Auto-release triggers (with [release])**
✅ **Hotfix executes immediately**
✅ **Error emails sent on failures**

---

## Next Steps After Testing

Once everything is tested and working:

1. **Remove test branches**
   ```bash
   git branch -D test/ci-automation test/failing-tests
   git push origin --delete test/ci-automation test/failing-tests
   ```

2. **Update documentation** with your specific setup details

3. **Train team** on using the automation

4. **Start using for real work!**

---

## 🎉 Congratulations!

If all tests pass, you have a **fully functional, automated CI/CD pipeline**!

**What you've verified:**
- ✅ Local testing works
- ✅ GitHub Actions automation works
- ✅ Bitrise integration works
- ✅ Auto-merge works
- ✅ Auto-release works
- ✅ Email notifications work
- ✅ Error handling works

**You're ready for production!** 🚀
