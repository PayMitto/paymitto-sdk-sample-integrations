# PayMitto SDK — React Native Example

A sample React Native app demonstrating how to integrate the PayMitto SDK using the [`react-native-paymitto-sdk`](https://www.npmjs.com/package/react-native-paymitto-sdk) wrapper.

## Prerequisites

- Node.js >= 20
- Xcode 16+ (iOS)
- Android Studio (Android), `minSdkVersion` 26+
- CocoaPods

## Setup

1. Clone this repo and enter the directory:

```bash
cd ReactNative
```

2. Enter your sandbox credentials in `App.tsx`:

```typescript
const SENDER_ID = '<YOUR_SENDER_ID>';
const CLIENT_ID = '<YOUR_CLIENT_ID>';
const CLIENT_SECRET = '<YOUR_CLIENT_SECRET>';
```

> **Security note:** This sample fetches the OAuth token directly from the device using `client_secret`, which keeps the demo self-contained but is **not** how production apps should be built. In production, your mobile app should call your backend, which performs the OAuth exchange against PayMitto and returns only the access token to the device.

3. Install dependencies:

```bash
npm install
```

4. Install iOS pods:

```bash
cd ios && pod install && cd ..
```

## Running

### iOS

```bash
npm run ios
```

Or open `ios/PayMittoReactNativeSample.xcworkspace` in Xcode and hit Run.

### Android

```bash
npm run android
```

## How It Works

This example uses the `react-native-paymitto-sdk` wrapper which handles all native bridge communication. The integration is entirely in JavaScript/TypeScript — no custom native modules are needed.

The key API is `startSDK()`, which accepts:

- **`configuration`** — Environment, appearance, localization settings
- **`fetchAccessTokenDetails`** — Async function that returns an auth token
- **`verifyFundsAndCreateTransfer`** — Async function that handles transfer submission. In this sample it is a stub that just echoes the request; in a real app, this is where you call your backend to verify funds and create the transfer. See the iOS and Android Compose samples for a complete reference implementation.
- **`onLoad`** / **`onClose`** — Optional lifecycle callbacks

See `App.tsx` for the full implementation.

## Platform Requirements

| Platform | Minimum Version |
|----------|----------------|
| iOS      | 16.0           |
| Android  | API 26         |
