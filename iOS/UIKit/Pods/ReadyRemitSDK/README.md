# ReadyRemit SDK - iOS

Binary distribution of the ReadyRemit SDK via Swift Package Manager and CocoaPods.

**Repository:** [https://github.com/BrightwellPayments/readyremit-sdk-ios](https://github.com/BrightwellPayments/readyremit-sdk-ios)

## Requirements

- iOS 16.0+
- Swift 5.9+
- Xcode 15.0+

## Developer Documentation
 [iOS](https://developer.readyremit.com/update/docs/mobile-sdk-ios)

## Installation

### Xcode

1. File → Add Package Dependencies
2. Enter: `https://github.com/BrightwellPayments/readyremit-sdk-ios`
3. Select version: `10.0.0`

### Swift Package Manager

Add the following to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/BrightwellPayments/readyremit-sdk-ios", exact: "10.0.0")
]
```

Then add `ReadyRemitSDK` to your target's dependencies:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "ReadyRemitSDK", package: "readyremit-sdk-ios")
    ]
)
```

### CocoaPods

Add the pod to your `Podfile`:

```ruby
pod 'ReadyRemitSDK', :git => 'https://github.com/BrightwellPayments/readyremit-sdk-ios.git', :tag => '10.0.0'
```

Then run:

```bash
pod install
```

## Usage

```swift
import ReadyRemitSDK

// Initialize and use ReadyRemit SDK
// See Developer Documentation above
```

## License

Proprietary - Brightwell, LLC
