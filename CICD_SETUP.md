# CI/CD Setup with Bitrise

## Bitrise Free Tier

**Yes, Bitrise offers a FREE tier!**

### Free Tier Includes:
- ✅ **Unlimited** builds for open-source projects
- ✅ **200 builds/month** for private projects (Hobby plan)
- ✅ **45 minutes** per build
- ✅ **2 concurrent builds** for open-source
- ✅ **1 concurrent build** for private projects
- ✅ Access to all integrations and steps
- ✅ Artifact storage (30 days)
- ✅ Test reports and screenshots

### Getting Started with Bitrise (FREE)

#### 1. Sign Up
1. Go to [https://www.bitrise.io](https://www.bitrise.io)
2. Sign up with GitHub/GitLab/Bitbucket (FREE)
3. Connect your repository

#### 2. Add Your App
1. Click "Add new app"
2. Select your repository
3. Choose the branch (main/develop)
4. Bitrise will auto-detect the project

#### 3. Configure bitrise.yml
The `bitrise.yml` file is already created in your project root. You can:
- **Option A**: Upload it to Bitrise dashboard
- **Option B**: Commit it to your repository (recommended)

#### 4. Set Environment Variables
In Bitrise dashboard, go to **Workflow → Env Vars** and add:
```
PLATFORM=android
DEVICE_NAME=Pixel_7_API_33
PLATFORM_VERSION=13.0
API_BASE_URL=https://jsonplaceholder.typicode.com
```

## Available Workflows

### 1. Primary Workflow (Full Test Suite)
Runs on every push to main/develop branches
```bash
# Includes:
- Unit tests
- API tests
- Security tests
- Smoke tests (on emulator)
- Generates HTML reports
```

### 2. Smoke Tests Workflow
Quick validation tests
```bash
# Trigger manually or on PR
- Runs @smoke tagged scenarios
- Fast execution (~5-10 mins)
```

### 3. API Tests Workflow
Backend API validation
```bash
# No emulator needed
- Runs @api tagged scenarios
- Very fast (~2-3 mins)
```

### 4. Unit Tests Workflow
RSpec unit tests
```bash
# No emulator needed
- Runs all unit tests
- Generates RSpec HTML report
```

## Triggering Builds

### Automatic Triggers
- **Push to main**: Runs primary workflow
- **Push to develop**: Runs primary workflow
- **Pull Request**: Runs primary workflow

### Manual Triggers
1. Go to Bitrise dashboard
2. Click "Start/Schedule a Build"
3. Select workflow (smoke_tests, api_tests, unit_tests)
4. Click "Start Build"

## Viewing Reports

After build completion:
1. Go to build details
2. Click **"Apps & Artifacts"** tab
3. Download:
   - `reports.zip` - HTML and JSON reports
   - `screenshots.zip` - Failure screenshots (if any)

## Cost Optimization Tips (Stay FREE)

### 1. Use Workflow Caching
Already configured in `bitrise.yml`:
```yaml
- cache-pull@2: {}
- cache-push@2:
    inputs:
    - cache_paths: |-
        vendor/bundle
        node_modules
```

### 2. Run Tests in Parallel
For faster execution within 45-min limit:
```bash
bundle exec parallel_cucumber features/ -n 2
```

### 3. Selective Test Execution
Run only necessary tests:
```bash
# For PRs - run smoke tests only
bundle exec cucumber -p smoke

# For main branch - run full suite
bundle exec cucumber
```

### 4. Skip Emulator for API Tests
API tests don't need emulator (saves ~5 mins):
```yaml
api_tests:
  steps:
  - script: bundle exec cucumber -p api
```

## Alternative Free CI/CD Options

If you need more build minutes:

### GitHub Actions (FREE)
- ✅ **2,000 minutes/month** for private repos
- ✅ **Unlimited** for public repos
- ✅ Linux, Windows, macOS runners

### GitLab CI (FREE)
- ✅ **400 minutes/month** for private repos
- ✅ **Unlimited** for public repos
- ✅ Shared runners

### CircleCI (FREE)
- ✅ **6,000 build minutes/month**
- ✅ 1 concurrent job
- ✅ Linux, Windows support

## Bitrise Configuration Files

### Main Configuration
- `bitrise.yml` - Workflow definitions

### Trigger Configuration
Already configured in `bitrise.yml`:
```yaml
trigger_map:
- push_branch: main
  workflow: primary
- pull_request_source_branch: "*"
  workflow: primary
```

## Monitoring Build Status

### Add Badge to README
```markdown
[![Build Status](https://app.bitrise.io/app/YOUR_APP_ID/status.svg?token=YOUR_TOKEN&branch=main)](https://app.bitrise.io/app/YOUR_APP_ID)
```

### Slack Notifications
Add Slack step in Bitrise:
1. Go to Workflow Editor
2. Add "Send a Slack message" step
3. Configure webhook URL

## Troubleshooting

### Build Timeout (45 min limit)
- Run fewer tests per build
- Use parallel execution
- Split into multiple workflows

### Emulator Issues
- Increase boot timeout: `boot_timeout: '600'`
- Use lighter emulator: `api_level: '30'`
- Consider using real device testing services

### Out of Build Minutes
- Optimize test execution time
- Use caching effectively
- Consider upgrading to paid plan ($36/month for 500 builds)

## Best Practices

1. **Keep builds under 30 minutes** for faster feedback
2. **Use caching** for dependencies
3. **Run unit/API tests first** (fast feedback)
4. **Run UI tests on specific branches** (main, develop)
5. **Archive test reports** for debugging
6. **Set up notifications** for build failures

## Support

- Bitrise Documentation: https://devcenter.bitrise.io
- Bitrise Community: https://discuss.bitrise.io
- Free tier limits: https://www.bitrise.io/pricing
