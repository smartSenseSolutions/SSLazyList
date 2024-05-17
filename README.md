
# SSLazyList Documentation

[SmartSense Solutions](https://www.smartsensesolutions.com/) has introduced `SSLazyList`, `SSLazyList` makes working with `List` in SwiftUI more efficient and elegant. By providing customizable loading views, no data messages, and flexible configurations, it serves as a wrapper for the standard `List` hence developer can leverage all features available in `List`
 
### Key Features

- **Loading View**: Easily set or use a default `Loading...` view to indicate data loading.
- **Cell Animation**: Enjoy elegant animations when cells appear.
- **No Data Found Message**: Display a default or custom message when no data is returned from an API.
- **Highly Configurable**: Enjoy 100% flexibility in usage with a wide range of configurable options.

### Usage Comparison

#### Standard SwiftUI List

With the standard SwiftUI `List`, a non-optional array of data models is required:

```swift
@State var users: [UserModel] = []

List(users) { user in
    UserDetailCell(user: user)
}
```

#### SSLazyList

With `SSLazyList`, you can use an optional array of data models and configure the list easily:

```swift
@State var users: [UserModel]?

var config: SSConfigLazyList {
    let configuration = SSConfigLazyList(animator: .auto(.bouncy, .always))
    return configuration
}

SSLazyList(data: users, rowContent: { user in
    UserDetailCell(user: user)
}, configuration: config)

```

### Configuration Example

Here's an example of how to configure `SSLazyList`:

```swift

var config: SSConfigLazyList {

    //SSLazyList configuration
    let configuration = SSConfigLazyList()
    
    //1. bouncy animation on each scroll
    configuration.setNewCellAnimation(animator: .auto(.bouncy, .always))
    //2. bouncy animation on cell visibily once
    configuration.setNewCellAnimation(animator: .auto(.bouncy, .once))
    //3. animate from right to left
    configuration.setNewCellAnimation(animator: .fromRight(.default))
    
    //1. using default loading indictor it array of data model is not set with API Response
    configuration.setLoadingView(viewType: .system)
    //2. provide custom view...
    configuration.setLoadingView(viewType: .customView(AnyView(Text("please wait..."))))
    
    //1. using default `No data found` view to show there is not data available aka blank array (eg. users = [])
    configuration.setNoDataView(viewType: .system)
    //2. provide custom view...
    configuration.setNoDataView(viewType: .customView(AnyView(Text("No user available."))))
    
    return configuration
}
```

This configuration allows you to leverage custom animations and system views for loading and no data states, ensuring a smooth and elegant user experience.

try the demo project for better understanding.

## Screenshots
<div style="display: flex; justify-content: space-between;">
    <img src="https://github.com/SmartAkashNara/SSLazyList/assets/160708458/d621a57c-4d58-4aba-889e-6b2d68737278" alt="No Data Found - SSLazyList" width="200" style="margin-right: 20px;" loop>
    <img src="https://github.com/SmartAkashNara/SSLazyList/assets/160708458/9e3383a6-c2bb-4acc-b4eb-d222c9964772" alt="Animate From Right - SSLazyList" width="200" style="margin-right: 20px;" loop>
    <img src="https://github.com/SmartAkashNara/SSLazyList/assets/160708458/50a11103-22d3-4ca9-950c-e8d6cb736cc1" alt="Animation Cell - SSLazyList" width="200" loop>
</div>

## Note
#### Data Model Requirements

The data model should implement the `Identifiable` protocol, just like what's needed for a standard SwiftUI `List`.

## Setup Instructions

[CocoaPods](http://cocoapods.org)

To integrate SSLazyList into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SSLazyList', '~> 1.0'
```
and in your code add `import SSLazyList`.

## Carthage
- We are working on it :)

[Swift Package Manager](https://swift.org/package-manager/)

When using Xcode 14 or later, you can install `SSLazyList` by going to your Project settings > `Swift Packages` and add the repository by providing the GitHub URL. Alternatively, you can go to `File` > `Swift Packages` > `Add Package Dependencies...`

```swift
dependencies: [
    .package(url: "https://github.com/smartSenseSolutions/SSLazyList.git", .upToNextMajor(from: "1.0"))
]
```

## Compatibility

- iOS 15.0+
- Swift 5.0+
- SwiftUI 
- XCode 14+

## Privacy
SSLazyList does not collect any kind of data in anyway.


## Contributing

We welcome contributions! Please see our [contributing guidelines](./CONTRIBUTING.md) for more details.

## License

The SwiftUI LazyList Library is available under the MIT license. See the [LICENSE](./LICENSE) file for more information.

----------
