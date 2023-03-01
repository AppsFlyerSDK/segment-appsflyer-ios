#!/bin/bash
echo "# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

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

end" > Podfile

