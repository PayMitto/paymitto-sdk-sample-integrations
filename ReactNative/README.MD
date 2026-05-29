# ReadyRemit SDK — React Native Example

A sample React Native app demonstrating how to integrate the ReadyRemit SDK using the [`react-native-ready-remit-sdk`](https://www.npmjs.com/package/react-native-ready-remit-sdk) wrapper.

## Prerequisites

- Node.js >= 20
- Xcode 16+ (iOS)
- Android Studio (Android), minSdkVersion 26+
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

Or open `ios/ReadyRemitReactNativeSample.xcworkspace` in Xcode and hit Run.

### Android

```bash
npm run android
```

## How It Works

This example uses the `react-native-ready-remit-sdk` wrapper which handles all native bridge communication. The integration is entirely in JavaScript/TypeScript — no custom native modules are needed.

The key API is `startSDK()`, which accepts:

- **`configuration`** — Environment, appearance, localization settings
- **`fetchAccessTokenDetails`** — Async function that returns an auth token
- **`verifyFundsAndCreateTransfer`** — Async function that handles transfer submission
- **`onLoad`** / **`onClose`** — Optional lifecycle callbacks

See `App.tsx` for the full implementation.

## Platform Requirements

| Platform | Minimum Version |
|----------|----------------|
| iOS      | 16.0           |
| Android  | API 26         |
