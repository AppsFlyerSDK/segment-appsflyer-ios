#!/bin/bash
echo "platform :ios, '12.0'
use_frameworks!

target 'segment-appsflyer-ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  # Pods for segment-appsflyer-ios
  pod 'Analytics'
  pod 'AppsFlyerFramework'

end

target 'SegmentAppsFlyeriOSTests' do
  # Comment the next line if you don't want to use dynamic frameworks
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
  
  # Configure project targets for Swift framework compatibility
  installer.aggregate_targets.each do |aggregate_target|
    aggregate_target.user_project.native_targets.each do |target|
      target.build_configurations.each do |config|
        if target.name == 'SegmentAppsFlyeriOSTests'
          # Test bundle MUST embed Swift standard libraries
          config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
        end
      end
    end
  end
end" > Podfile

