# ReadyRemitHostPods (UIKit)

A sample iOS application demonstrating how to integrate the ReadyRemit SDK into a UIKit-based app using CocoaPods.

## Overview

This app serves as a reference implementation for integrating the ReadyRemit SDK using UIKit. It presents the SDK view modally (full-screen) from a `UIViewController` by wrapping the SDK's SwiftUI view in a `UIHostingController`.

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- CocoaPods 1.16+

## Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd iOS/UIKit
   ```

2. **Install CocoaPods** (if not already installed)
   ```bash
   sudo gem install cocoapods
   ```

3. **Install dependencies**
   ```bash
   pod install
   ```

4. **Open the workspace**
   ```bash
   open ReadyRemitHostPods.xcworkspace
   ```
   > **Note:** Always open the `.xcworkspace` file (not `.xcodeproj`) when using CocoaPods.

5. **Configure credentials**

   Update the sandbox credentials in `ReadyRemitHostPods/ViewModel.swift` with your own:
   ```swift
   "client_id": "YOUR_CLIENT_ID",
   "client_secret": "YOUR_CLIENT_SECRET",
   "sender_id": "YOUR_SENDER_ID"
   ```

6. **Build and run**

## Project Structure

```
ReadyRemitHostPods/
├── AppDelegate.swift                # App entry point
├── SceneDelegate.swift              # Scene lifecycle management
├── ViewController.swift             # Root view controller with SDK launch button
├── ViewModel.swift                  # SDK integration & API logic
├── CreateOAuthTokenResponse.swift   # OAuth token response model
├── CreateTransferResponse.swift     # Transfer creation response model
├── ReadQuoteDetailsResponse.swift   # Quote details response model
├── Info.plist                       # App configuration
├── Base.lproj/
│   ├── Main.storyboard              # Main UI storyboard
│   └── LaunchScreen.storyboard      # Launch screen
└── Assets.xcassets/                 # App icons & colors
```

## SDK Integration

### Starting the SDK

The SDK is launched from `ViewModel` and the returned SwiftUI view is observed by `ViewController`:

```swift
ReadyRemit.shared.startSDK(
    configuration: .init(environment: .sandbox),
    fetchAccessTokenDetails: fetchAccessTokenDetails,
    verifyFundsAndCreateTransfer: verifyFundsAndCreateTransfer,
    onDismiss: {
        // Handle SDK dismissal
    }
) { readyRemitSDKView in
    // Store the view to trigger observation
}
```

### Presenting the SDK from UIKit

The `ViewController` uses Swift's Observation framework to react when the SDK view becomes available, then presents it full-screen via `UIHostingController`:

```swift
private func setupObservation() {
    withObservationTracking {
        _ = viewModel.readyRemitItem
    } onChange: { [weak self] in
        guard let self else { return }
        Task {
            await MainActor.run {
                if let readyRemitItem = self.viewModel.readyRemitItem {
                    let hostingController = UIHostingController(rootView: AnyView(readyRemitItem.view))
                    hostingController.modalPresentationStyle = .fullScreen
                    self.present(hostingController, animated: true)
                }
            }
        }
    }
}
```

### Required Callbacks

#### 1. Fetch Access Token
```swift
func fetchAccessTokenDetails() async throws -> AccessTokenDetails {
    // POST to /v1/oauth/token with client credentials
    // Return a response conforming to AccessTokenDetails
}
```

#### 2. Verify Funds and Create Transfer
```swift
func verifyFundsAndCreateTransfer(
    transferRequest: TransferRequest
) async throws(ReadyRemitError) -> TransferDetails {
    // GET quote details for transferRequest.quoteHistoryId
    // POST to /v1/transfers to create the transfer
    // Return a response conforming to TransferDetails
}
```

## Dependencies

Managed via CocoaPods (`Podfile`):

```ruby
platform :ios, '17.0'

target 'ReadyRemitHostPods' do
  use_frameworks!
  pod 'ReadyRemitSDK', :git => 'https://github.com/BrightwellPayments/readyremit-sdk-ios.git', :tag => '10.0.0'
end
```

## Environment

The app is configured to use the **sandbox** environment by default:

```swift
configuration: .init(environment: .sandbox)
```

For production, change to:

```swift
configuration: .init(environment: .production)
```

## License

Copyright © 2026 Brightwell. All rights reserved.
