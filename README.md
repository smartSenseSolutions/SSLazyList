
# SSLazyList Documentation

[SmartSense Solutions](https://www.smartsensesolutions.com/) has introduced `SSLazyList`, `SSLazyList` makes working with `List` in SwiftUI more efficient and elegant. By providing customisable list cell animations, loading views, no data messages, and flexible configurations, it serves as a wrapper for the standard `List` hence developer can leverage all features available in `List`
 
### Key Features

- **Pagination**: Easy to manage pagination and reloading of data
- - **Refresh/Reload data**: Easily set Pull to refresh with your custom views and stop handler...
- - **Load More data**: Easily to intigrate load more feature with Closing handler...
- **Cell Animation**: Enjoy elegant animations when cells appear.
- **Custom Views**
- - **Loading View**: Easily set or use a default `Loading...` view to indicate data loading.
- - **No Data Found Message**: Display a default or custom message when no data is returned from an API.
- **Highly Configurable**: Enjoy 100% flexibility in usage with a wide range of configurable options.

### Usage Comparison

#### Standard SwiftUI List

With the standard SwiftUI `List`, a non-optional array of data models is required:

```swift
@State var records: [Record] = []

List(records) { record in
    ListRowView(record: record)
}
```

#### SSLazyList

With `SSLazyList`, you can use an optional array of data models and configure the list easily:

```swift
@State private var records : [Record]? = nil

var config: SSConfigLazyList {
    let configuration = SSConfigLazyList(animator: .auto(.bouncy, .always))
    return configuration
}

SSLazyList(data: records, rowContent: { record in
    VStack{ // your row content ...
          Spacer(minLength: 10)
          Text(record.value).font(.title)
    }
}, configuration: config)

```

### Configuration Example

Here's an example of how to configure `SSLazyList`:

```swift

var config: SSConfigLazyList {

    //SSLazyList configuration
    let configuration = SSConfigLazyList()

    ///`[UseCase 1]`
    //1. bouncy animation on each scroll
    configuration.setNewCellAnimation(animator: .auto(.bouncy, .always))
    //2. bouncy animation on cell visibily once
    configuration.setNewCellAnimation(animator: .auto(.bouncy, .once))
    //3. animate from right to left
    configuration.setNewCellAnimation(animator: .fromRight(.default))

    ///`[UseCase 2]`
    //1. using default loading indictor it array of data model is not set with API Response
    configuration.setLoadingView(viewType: .system)
    //2. provide custom view...
    configuration.setLoadingView(viewType: .customView(AnyView(Text("please wait..."))))

    ///`[UseCase 3]`
    //1. using default `No data found` view to show there is not data available aka blank array (eg. users = [])
    configuration.setNoDataView(viewType: .system)
    //2. provide custom view...
    configuration.setNoDataView(viewType: .customView(AnyView(Text("No user available."))))

    ///`**[UseCase 4]**`
    //1. set pulltorefresh view
    configuration.setReloadType(viewType: SSPullToRefresh(displayView: {
            AnyView(DisaplyDraggingView(title: "Pull-Down to Refresh"))
        }, loadingView: {
            AnyView(ZStack{
                progressView
            })
        }, onTrigger: { allowAgain in
            print("refresh action")

            ///API CALL GOES HERE...
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                
                ///reseting array with fresh server response
                self.start = 0
                self.records = DataPaginationService.paginateData(dataList: localDb, start: start, length: length).data
                
                ///AFTER API CALL , Call `allowAgain` Closure with value `true` to allow sytem to show pulltoRefresh again
                allowAgain(true)
            })
        }))

    ///`**[UseCase 5]**`
    //1. set LoadMore View in simple way:
        configuration.setLoadMoreType(viewType: SSLoadMore(type: .onPullUp, displayView: {
            AnyView(DisaplyDraggingView(title: "Pull-Up to Load More"))
        }, loadingView: {
            AnyView(ZStack{
                progressView
            })
        }, onTrigger: { hasMoreRecords in
            print("page loading action")
            if self.records != nil{
                ///API CALL GOES HERE...
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                   
                    ///Appending server response to array
                    self.records!.append(contentsOf: DataPaginationService.paginateData(dataList: localDb, start: start, length: length).data)

                    ///AFTER API CALL , Call `allowAgain` Closure with value `true`
                    ///To allow sytem to show  `load more`  again if there is More data available on server or in DB.
                    hasMoreRecords(self.records!.count < localDb.count)
                })
            }else{
                ///Default when No data...
                hasMoreRecords(false)
            }
        }))
    return configuration
}
```

This configuration allows you to leverage custom animations and system views for loading and no data states, ensuring a smooth and elegant user experience.

try the demo project for better understanding.

## Screenshots
<div style="display: flex; justify-content: space-between;">
     <img src="https://github.com/KalpeshJetaniSS/SSLazyList/assets/160708458/bf14e8d0-adfd-4cdc-9576-0724d4d7a3c2" alt="PulltoRefresh and LoadMore - SSLazyList" width="200" style="margin-right: 20px;" loop>
     <img src="https://github.com/KalpeshJetaniSS/SSLazyList/assets/160708458/e64458cc-9a11-4510-87dd-d0ee80d5a3b3" alt="Animate From Right - SSLazyList" width="200" style="margin-right: 20px;" loop>
     <img src="https://github.com/KalpeshJetaniSS/SSLazyList/assets/160708458/78b1d17a-84a7-47c5-8855-ff5f71f0c72a" alt="Animation Cell - SSLazyList" width="200" loop>
     <img src="https://github.com/KalpeshJetaniSS/SSLazyList/assets/160708458/95f2a014-1665-44fe-a2d1-8888d15481d9" alt="No Data Found - SSLazyList" width="200" style="margin-right: 20px;" loop>
</div>

## Note
#### Data Model Requirements

The data model should implement the `Identifiable` protocol, just like what's needed for a standard SwiftUI `List`.

## Setup Instructions

[cocoapods](https://cocoapods.org/pods/SSLazyList)

[Cocoapods Source available here](https://github.com/smartSenseSolutions/SSLazyList/tree/cocoapods)

To integrate SSLazyList into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SSLazyList', '~> 1.2.0'
```

and in your code add **import SSLazyList**.


## [Swift Package Manager](https://swift.org/package-manager/)

When using Xcode 14 or later, you can install `SSLazyList` by going to your Project settings > `Swift Packages` and add the repository by providing the GitHub URL. Alternatively, you can go to `File` > `Swift Packages` > `Add Package Dependencies...`

![Using_SwiftPackageManager](https://github.com/smartSenseSolutions/SSLazyList/assets/160708458/3c9b41b9-2783-4f0e-b7da-89e9b5e77c92)

```swift
dependencies: [
    .package(url: "https://github.com/smartSenseSolutions/SSLazyList.git", .branch("main"))
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

## License

The SwiftUI LazyList Library is available under the MIT license. See the [LICENSE](./LICENSE) file for more information.

----------
