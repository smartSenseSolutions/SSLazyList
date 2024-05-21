# SSLazyList

[![CI Status](https://img.shields.io/travis/smartsensesolutions/SSLazyList.svg?style=flat)](https://travis-ci.org/smartsensesolutions/SSLazyList)
[![Version](https://img.shields.io/cocoapods/v/SSLazyList.svg?style=flat)](https://cocoapods.org/pods/SSLazyList)
[![License](https://img.shields.io/cocoapods/l/SSLazyList.svg?style=flat)](https://cocoapods.org/pods/SSLazyList)
[![Platform](https://img.shields.io/cocoapods/p/SSLazyList.svg?style=flat)](https://cocoapods.org/pods/SSLazyList)

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first. or just use terminal command `pod try SSLazyList`

With `SSLazyList`, you can use an optional array of data models and configure the list easily:

```swift
import SSLazyList

//...

@State var users: [UserModel]?

var config: SSConfigLazyList {
    let configuration = SSConfigLazyList(animator: .auto(.bouncy, .always))
    return configuration
}

//...

SSLazyList(data: users, rowContent: { user in
    UserDetailCell(user: user)
}, configuration: config)

//...
```


## Requirements
The data model should implement the `Identifiable` protocol, just like what's needed for a standard SwiftUI `List`.


## Installation
SSLazyList is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SSLazyList', '~> 1.0.0'
```
and in your code add `import SSLazyList`.

##[Swift Package Manager](https://swift.org/package-manager/)

When using Xcode 14 or later, you can install `SSLazyList` by going to your Project settings > `Swift Packages` and add the repository by providing the GitHub URL. Alternatively, you can go to `File` > `Swift Packages` > `Add Package Dependencies...`

```swift
dependencies: [
    .package(url: "https://github.com/smartSenseSolutions/SSLazyList.git", .upToNextMajor(from: "1.0"))
]
```

## Compatibility
- iOS v15.0+
- Swift v5.0+
- SwiftUI 
- XCode v14+

## Privacy
SSLazyList does not collect any kind of data in anyway.


## Contributing
We welcome contributions! Please see our [contributing guidelines](./CONTRIBUTING.md) for more details.

## Author
SmartSense Consulting Solutions Pvt. Ltd., open-source@smartsensesolutoins.com

## License
The SwiftUI LazyList Library is available under the MIT license. See the [LICENSE](./LICENSE) file for more information.

