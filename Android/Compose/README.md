# PayMitto SDK — Android Compose Sample

A sample Android application demonstrating how to integrate the PayMitto SDK using Jetpack Compose and Kotlin.

## Requirements

- Android Studio Ladybug or newer
- JDK 21
- Kotlin 2.1+
- Android Gradle Plugin 8.9+
- `compileSdk` 36 / `minSdk` 26

## Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Android/Compose
   ```

2. **Open in Android Studio**

   Use `File > Open...` and select the `Android/Compose` folder. Gradle sync will pull all dependencies, including the PayMitto SDK from Maven.

3. **Configure credentials**

   The sample expects sandbox credentials in `MainViewModel.kt`. Replace the placeholders with your values:
   ```kotlin
   private val senderId = "<your_sender_id>"
   private val clientId = "<your_client_id>"
   private val clientSecret = "<your_client_secret>"
   ```

   > **Security note:** This sample fetches the OAuth token directly from the device using `client_secret`, which keeps the demo self-contained but is **not** how production apps should be built. In production, your mobile app should call your backend, which performs the OAuth exchange against PayMitto and returns only the access token to the device.

4. **Run**

   Select a device or emulator (API 26+) and hit Run.

## Project Structure

```
app/src/main/java/com/paymitto/composeSampleApp/
├── MainActivity.kt            # App entry point + Compose UI
├── MainViewModel.kt           # SDK integration & auth/transfer logic
├── MainState.kt               # UI state holder
├── network/                   # Retrofit service + request/response models
├── ui/theme/                  # Compose theme (colors, typography)
└── util/                      # Helpers
```

## SDK Integration

The integration lives in `MainViewModel.kt`. The key entry point is:

```kotlin
PayMitto.startSdk(
    activity = activity,
    readyRemitConfiguration = configuration,  // see note below
)
```

> **Note on the parameter name:** the SDK parameter is currently `readyRemitConfiguration` for backwards compatibility with the pre-rebrand API. The object passed in is a `PayMittoConfiguration`. This naming will be reconciled in a future SDK release.

`PayMittoConfiguration` requires two callbacks:

#### 1. Authenticate

```kotlin
authenticateIntoTheSdk = {
    // POST to your /oauth/token endpoint
    // Return AuthenticationResult.Success(AccessTokenDetails(...))
    // or AuthenticationResult.Failure(...) on error
}
```

#### 2. Submit transfer

```kotlin
submitTransfer = { transferRequest ->
    // Verify funds and submit the transfer through your backend
    // Return TransferSubmissionResult.Success(transferId = "...")
    // or TransferSubmissionResult.Failure(...) on error
}
```

## Dependencies

Managed via Gradle version catalog (`gradle/libs.versions.toml`). The PayMitto SDK is pulled from Maven:

```kotlin
implementation(libs.payMitto.sdk)  // com.paymitto.android:PayMittoSDK:11.0.4
```

## Environment

The sample defaults to the **sandbox** environment via `MainViewModel.kt`. For production, point the auth URL and SDK environment to production endpoints.

## License

Copyright © 2026 PayMitto, LLC. All rights reserved.
