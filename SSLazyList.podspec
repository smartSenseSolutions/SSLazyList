#
# Be sure to run `pod lib lint SSLazyList.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SSLazyList'
  s.version          = '1.1.0'
  s.summary          = 'SSLazyList is a wrapper for the standard SwiftUI List'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
[SmartSense Solutions](https://www.smartsensesolutions.com/) has introduced `SSLazyList`, `SSLazyList` makes working with `List` in SwiftUI more efficient and elegant. By providing customisable list cell animations, loading views, no data messages, and flexible configurations, it serves as a wrapper for the standard `List` hence developer can leverage all features available in `List`
  ### Key Features

  - **Loading View**: Easily set or use a default `Loading...` view to indicate data loading.
  - **Cell Animation**: Enjoy elegant animations when cells appear.
  - **No Data Found Message**: Display a default or custom message when no data is returned from an API.
  - **Highly Configurable**: Enjoy 100% flexibility in usage with a range of configurable options.
                       DESC

  s.homepage         = 'https://github.com/smartsensesolutions/SSLazyList'
  s.screenshots     = 'https://github.com/smartsensesolutions/SSLazyList/assets/160708458/e64458cc-9a11-4510-87dd-d0ee80d5a3b3', 'https://github.com/smartsensesolutions/SSLazyList/assets/160708458/78b1d17a-84a7-47c5-8855-ff5f71f0c72a', 'https://github.com/smartsensesolutions/SSLazyList/assets/160708458/95f2a014-1665-44fe-a2d1-8888d15481d9'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'smartsensesolutions' => 'open-source@smartsensesolutoins.com' }
  s.source           = { :git => 'https://github.com/smartsensesolutions/SSLazyList.git', :tag => s.version.to_s}
  s.social_media_url = 'https://twitter.com/smartsense13'

  #s.platform     = :ios, '15.0'
  s.ios.deployment_target = '15.0'
  s.platforms = {
        "ios": "15.0"
    }
  s.source_files = 'Sources/*.swift'
  s.swift_version = '5.0'
  
  # s.resource_bundles = {
  #   'SSLazyList' => ['SSLazyList/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'Foundation', 'SwiftUI'
  # s.dependency 'AFNetworking', '~> 2.3'
end
