# Release Train Flow Diagram

## Standard Release Train (12-hour timeline)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          RELEASE TRAIN WORKFLOW                              │
└─────────────────────────────────────────────────────────────────────────────┘

    START: GitHub Actions Trigger
           ↓
    ┌──────────────────────────────────────┐
    │  STAGE 0: Build Release (X hrs)      │
    │  ────────────────────────────────    │
    │  • Checkout master branch            │
    │  • Run tests (unit, API)             │
    │  • Create release tag                │
    │  • Trigger Bitrise builds            │
    │    - Android APK                     │
    │    - iOS IPA                         │
    │  • Generate release notes            │
    └──────────────────────────────────────┘
           ↓
    ⏰ WAIT 2 HOURS
           ↓
    ┌──────────────────────────────────────┐
    │  STAGE 1: Internal (X + 2 hrs)       │
    │  ────────────────────────────────    │
    │  • Deploy to Firebase                │
    │  • Deploy to Google Play Internal    │
    │  • Notify internal testers           │
    └──────────────────────────────────────┘
           ↓
    ⏰ WAIT 2 HOURS
           ↓
    ┌──────────────────────────────────────┐
    │  STAGE 2: Friends & Family (X+4 hrs) │
    │  ────────────────────────────────    │
    │  • Deploy to TestFlight              │
    │  • Deploy to Google Play Internal    │
    │  • Notify friends & family           │
    └──────────────────────────────────────┘
           ↓
    ⏰ WAIT 4 HOURS
           ↓
    ┌──────────────────────────────────────┐
    │  STAGE 3: Beta Testers (X + 8 hrs)   │
    │  ────────────────────────────────    │
    │  • Deploy to TestFlight Beta         │
    │  • Deploy to Google Play Beta        │
    │  • Notify beta testers               │
    └──────────────────────────────────────┘
           ↓
    ⏰ WAIT 2 HOURS
           ↓
    ┌──────────────────────────────────────┐
    │  STAGE 4: Submit Review (X + 10 hrs) │
    │  ────────────────────────────────    │
    │  • Submit to App Store Review        │
    │  • Submit to Google Play Review      │
    │  • Notify team                       │
    └──────────────────────────────────────┘
           ↓
    ⏰ WAIT 2 HOURS
           ↓
    ┌──────────────────────────────────────┐
    │  STAGE 5: Production (X + 12 hrs)    │
    │  ────────────────────────────────    │
    │  • Release to App Store              │
    │  • Release to Google Play Store      │
    │  • Create GitHub Release             │
    │  • Notify team                       │
    └──────────────────────────────────────┘
           ↓
    ✅ RELEASE COMPLETE
```

## Hotfix Flow (Immediate - No Delays)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                            HOTFIX WORKFLOW                                   │
└─────────────────────────────────────────────────────────────────────────────┘

    START: GitHub Actions Trigger (Release Type: hotfix)
           ↓
    ┌──────────────────────────────────────┐
    │  Build & Test (Immediate)            │
    │  ────────────────────────────────    │
    │  • Checkout master                   │
    │  • Run critical tests                │
    │  • Build hotfix                      │
    └──────────────────────────────────────┘
           ↓ (No Wait)
    ┌──────────────────────────────────────┐
    │  Deploy to Internal (Immediate)      │
    └──────────────────────────────────────┘
           ↓ (No Wait)
    ┌──────────────────────────────────────┐
    │  Deploy to Beta (Immediate)          │
    └──────────────────────────────────────┘
           ↓ (No Wait)
    ┌──────────────────────────────────────┐
    │  Submit for Review (Immediate)       │
    └──────────────────────────────────────┘
           ↓ (No Wait)
    ┌──────────────────────────────────────┐
    │  Release to Production (Immediate)   │
    └──────────────────────────────────────┘
           ↓
    ✅ HOTFIX COMPLETE (All stages in minutes, not hours)
```

## Advanced Controls

### Stop Release Train

```
    Running Release Train
           ↓
    User triggers "Stop Release Train"
           ↓
    ┌──────────────────────────────────────┐
    │  Stop Workflow                       │
    │  ────────────────────────────────    │
    │  • Cancel workflow by Run ID         │
    │  • Generate stop report              │
    │  • Notify team                       │
    └──────────────────────────────────────┘
           ↓
    ❌ RELEASE TRAIN STOPPED
```

### Replace Release Train

```
    Running Release Train (v1.0.0)
           ↓
    User triggers "Replace Release Train"
           ↓
    ┌──────────────────────────────────────┐
    │  Stop Current Release                │
    │  ────────────────────────────────    │
    │  • Cancel current workflow           │
    │  • Wait for cancellation             │
    └──────────────────────────────────────┘
           ↓
    ┌──────────────────────────────────────┐
    │  Start New Release (v1.0.1)          │
    │  ────────────────────────────────    │
    │  • Start from specified stage        │
    │  • Generate replacement report       │
    │  • Notify team                       │
    └──────────────────────────────────────┘
           ↓
    ✅ NEW RELEASE TRAIN STARTED
```

### Skip to Stage

```
    START: Release Train with "Skip to Stage: beta"
           ↓
    ⏭️  SKIP: Build Release
    ⏭️  SKIP: Internal Testers
    ⏭️  SKIP: Friends & Family
           ↓
    ┌──────────────────────────────────────┐
    │  START HERE: Beta Testers            │
    └──────────────────────────────────────┘
           ↓
    Continue with remaining stages...
```

### Stop at Stage

```
    START: Release Train with "Stop at Stage: beta"
           ↓
    Build Release → Internal → Friends & Family → Beta
           ↓
    ┌──────────────────────────────────────┐
    │  STOP HERE: Beta Testers             │
    └──────────────────────────────────────┘
           ↓
    🛑 RELEASE TRAIN STOPPED AT BETA
    (Does not proceed to Review or Production)
```

## Test Execution in Bitrise

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        BITRISE TEST WORKFLOW                                 │
└─────────────────────────────────────────────────────────────────────────────┘

    Install Dependencies
           ↓
    Start Appium Server
           ↓
    ┌──────────────────────────────────────┐
    │  ANDROID TESTS (Emulator)            │
    │  ────────────────────────────────    │
    │  • Create Android Emulator           │
    │  • Wait for emulator boot            │
    │  • Run 1 Unit Test                   │
    │  • Run 1 API Test                    │
    │  • Run 1 Security Test               │
    │  • Run 1 Android UI Test             │
    │  • Stop emulator                     │
    └──────────────────────────────────────┘
           ↓
    ┌──────────────────────────────────────┐
    │  iOS TESTS (Simulator)               │
    │  ────────────────────────────────    │
    │  • Start iOS Simulator               │
    │  • Run 1 iOS UI Test                 │
    └──────────────────────────────────────┘
           ↓
    Generate Reports
           ↓
    Deploy Artifacts
           ↓
    ✅ TESTS COMPLETE
```

## Deployment Workflow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      DEPLOYMENT WORKFLOW                                     │
└─────────────────────────────────────────────────────────────────────────────┘

    GitHub Actions Trigger
           ↓
    ┌──────────────────────────────────────┐
    │  Bitrise Build                       │
    │  ────────────────────────────────    │
    │  Android:                            │
    │  • Build APK                         │
    │  • Sign APK                          │
    │  • Upload to Google Play             │
    │                                      │
    │  iOS:                                │
    │  • Build IPA                         │
    │  • Sign with certificate             │
    │  • Upload to App Store Connect       │
    └──────────────────────────────────────┘
           ↓
    ┌──────────────────────────────────────┐
    │  Distribution                        │
    │  ────────────────────────────────    │
    │  Internal:                           │
    │  • Firebase App Distribution         │
    │                                      │
    │  Beta:                               │
    │  • TestFlight (iOS)                  │
    │  • Google Play Beta (Android)        │
    │                                      │
    │  Production:                         │
    │  • App Store (iOS)                   │
    │  • Google Play Store (Android)       │
    └──────────────────────────────────────┘
           ↓
    ✅ DEPLOYMENT COMPLETE
```

## Decision Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                      RELEASE TYPE DECISION                                   │
└─────────────────────────────────────────────────────────────────────────────┘

    User starts workflow
           ↓
    ┌──────────────────────────────────────┐
    │  Is this a hotfix?                   │
    └──────────────────────────────────────┘
           ↓                    ↓
        YES                   NO
           ↓                    ↓
    ┌─────────────┐    ┌─────────────────┐
    │  HOTFIX     │    │  RELEASE TRAIN  │
    │  FLOW       │    │  FLOW           │
    │             │    │                 │
    │  All stages │    │  Staged with    │
    │  immediate  │    │  time delays    │
    └─────────────┘    └─────────────────┘
           ↓                    ↓
           └────────┬───────────┘
                    ↓
            Deploy to stores
                    ↓
            ✅ COMPLETE
```

## Parallel Execution

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    PARALLEL BUILD & DEPLOY                                   │
└─────────────────────────────────────────────────────────────────────────────┘

    Release Train Started
           ↓
    ┌─────────────────────┬─────────────────────┐
    ↓                     ↓                     ↓
┌─────────┐         ┌─────────┐         ┌─────────┐
│ Android │         │   iOS   │         │  Tests  │
│  Build  │         │  Build  │         │         │
│         │         │         │         │         │
│ • APK   │         │ • IPA   │         │ • Unit  │
│ • Sign  │         │ • Sign  │         │ • API   │
│ • Upload│         │ • Upload│         │ • UI    │
└─────────┘         └─────────┘         └─────────┘
    ↓                     ↓                     ↓
    └─────────────────────┴─────────────────────┘
                          ↓
                  All builds complete
                          ↓
                  Proceed to deployment
```

## Timeline Visualization

```
Hour 0  ├─── Build Release ───┤
        │                     │
Hour 2  │                     ├─── Internal Testers ───┤
        │                     │                        │
Hour 4  │                     │                        ├─── Friends & Family ───┤
        │                     │                        │                        │
Hour 6  │                     │                        │                        │
        │                     │                        │                        │
Hour 8  │                     │                        │                        ├─── Beta Testers ───┤
        │                     │                        │                        │                    │
Hour 10 │                     │                        │                        │                    ├─── Submit Review ───┤
        │                     │                        │                        │                    │                     │
Hour 12 │                     │                        │                        │                    │                     ├─── Production ───┤
        │                     │                        │                        │                    │                     │                  │
        └─────────────────────┴────────────────────────┴────────────────────────┴────────────────────┴─────────────────────┴──────────────────┘
        
        Total Duration: 12 hours from start to production
```

## Error Handling

```
    Stage Running
           ↓
    ┌──────────────────────────────────────┐
    │  Error Detected?                     │
    └──────────────────────────────────────┘
           ↓                    ↓
        YES                   NO
           ↓                    ↓
    ┌─────────────┐    ┌─────────────────┐
    │  STOP       │    │  CONTINUE       │
    │  • Log error│    │  • Next stage   │
    │  • Notify   │    │                 │
    │  • Report   │    │                 │
    └─────────────┘    └─────────────────┘
           ↓                    ↓
    User can:                  ↓
    • Fix & Replace      ✅ SUCCESS
    • Stop completely
    • Skip to next stage
```
