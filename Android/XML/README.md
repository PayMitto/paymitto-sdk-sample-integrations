# Android XML Sample (Legacy)

> **Status:** This sample has **not yet been updated** to PayMitto SDK v11.0.0. It still references the pre-rebrand Brightwell ReadyRemit naming (package `com.brightwell.readyremit.androisample`) and consumes a local `.aar` artifact instead of the published Maven dependency. For the up-to-date integration reference, use the [Compose sample](../Compose/README.md).

A sample Android application demonstrating SDK integration using the classic Android View system (XML layouts) and Kotlin.

## Requirements

- Android Studio Ladybug or newer
- JDK 17
- Kotlin 1.9+
- Android Gradle Plugin 8.2+
- `compileSdk` 34 / `minSdk` 29

## Setup

1. **Open in Android Studio**

   Use `File > Open...` and select the `Android/XML` folder.

2. **SDK binary**

   The sample currently loads the SDK from a local AAR at `app/libs/readyremit.aar`. This will be replaced by a Maven dependency when the sample is migrated to PayMitto v11.0.0.

3. **Configure credentials**

   Replace the placeholder credentials in `MainViewModel.kt` with your sandbox values.

   > **Security note:** This sample fetches the OAuth token directly from the device. In production, your mobile app should call your backend for token issuance and never embed `client_secret` in the mobile bundle.

4. **Run**

   Select a device or emulator (API 29+) and hit Run.

## Project Structure

```
app/src/main/java/com/brightwell/readyremit/androisample/
├── ui/
│   ├── MainActivity.kt        # App entry point + activity launcher
│   └── MainViewModel.kt       # Auth + SDK launch logic
└── network/                   # Retrofit service + request/response models
```

## Planned Updates

The pending migration to PayMitto v11.0.0 will include:

- Renaming the package and `applicationId` from `com.brightwell.readyremit.*` to `com.paymitto.*`
- Replacing the local `readyremit.aar` with the published Maven artifact (`com.paymitto.android:PayMittoSDK`)
- Bumping `compileSdk` / `targetSdk` to 36 to match the Compose sample
- Updating the toolchain (AGP, Kotlin) to match the Compose sample
- Removing unused dependencies (Mixpanel, LaunchDarkly, Dagger, etc.) that were carried over from a previous host project

Until that work lands, treat the Compose sample as the authoritative reference for integrating the latest PayMitto SDK.

## License

Copyright © 2026 PayMitto, LLC. All rights reserved.
