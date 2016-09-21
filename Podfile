# Uncomment this line to define a global platform for your project
platform :ios, '7.0'

source 'https://github.com/CocoaPods/Specs.git'

workspace 'BlueShiftDemoiOSApp.xcworkspace'


target 'BlueShiftDemoiOSApp' do
  pod 'SVProgressHUD'
  pod 'JSONModel'
  pod 'ViewDeck', '~> 2.2.11'
  pod 'SDWebImage'
  pod 'IQKeyboardManager'
  pod 'MJPopupViewController'
  pod 'BlueShift-iOS-SDK', :git=> 'https://github.com/blueshift-labs/Blueshift-iOS-SDK', :branch=> 'development'
  #pod 'BlueShift-iOS-SDK', :path=> '/Users/shahas/Desktop/blueGitHub/Blueshift-iOS-SDK'
end

target 'BlueShiftPushService' do
    pod 'BlueShift-iOS-SDK/AppExtension', :git=> 'https://github.com/blueshift-labs/Blueshift-iOS-SDK', :branch=> 'development'
end
