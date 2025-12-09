#!/bin/bash
echo "platform :ios, '12.0'

target 'segment-appsflyer-ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for segment-appsflyer-ios
  pod 'Analytics'
  pod 'AppsFlyerFramework'

end

target 'SegmentAppsFlyeriOSTests' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SegmentAppsFlyeriOSTests
  pod 'OCMock'

end

# Post-install hook to fix Swift linking issues with AppsFlyer SDK
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end" > Podfile

