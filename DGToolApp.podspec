#
# Be sure to run `pod lib lint DGToolApp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DGToolApp'
  s.version          = '0.3.2'
  s.summary          = 'This is DGToolApp.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'DGToolApp by Devgster'

  s.homepage         = 'https://github.com/devgster/DGToolApp'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kyungwoo Park' => 'devgster@gmail.com' }
  s.source           = { :git => 'https://github.com/devgster/DGToolApp.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '7.0'
    s.requires_arc = false


    s.source_files = 'DGToolApp/Classes/**/*'

  # s.resource_bundles = {
  #   'DGToolApp' => ['DGToolApp/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'


    s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => "${PODS_ROOT}/GoogleAnalytics/Libraries", 'OTHER_LDFLAGS' => '$(inherited) -ObjC -l"GoogleAnalytics" -l"c++" -l"sqlite3" -l"z" -framework "CoreData" -framework "Crashlytics" -framework "Fabric" -framework "Security" -framework "SystemConfiguration" -framework "UIKit"', "FRAMEWORK_SEARCH_PATHS" => '"${PODS_ROOT}/Fabric/iOS" "${PODS_ROOT}/Crashlytics/iOS"'}

    s.frameworks = 'UIKit', 'CoreTelephony'

#OTHER_LDFLAGS' => '$(inherited) -ObjC -l"GoogleAnalytics" -l"c++" -l"sqlite3" -l"z" -framework "CoreData" -framework "Crashlytics" -framework "Fabric" -framework "Security" -framework "SystemConfiguration" -framework "UIDeviceIdentifier" -framework "UIKit"',

    s.dependency 'GoogleAnalytics', '~> 3.14'
    s.dependency 'UIDeviceIdentifier', '~> 1.0'
    s.dependency 'Crashlytics', '~> 3.7'

end

#pod lib lint --use-libraries --no-clean --verbose
#pod trunk push DGToolApp.podspec  --verbose --use-libraries

