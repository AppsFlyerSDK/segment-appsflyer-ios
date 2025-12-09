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

# Post-install hook to ensure Swift framework compatibility
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
  
  # Configure main project for Swift framework compatibility
  installer.aggregate_targets.each do |aggregate_target|
    aggregate_target.user_project.native_targets.each do |target|
      target.build_configurations.each do |config|
        if target.name == 'segment-appsflyer-ios'
          # Make missing Swift compatibility libraries non-fatal
          # These are backward compatibility shims removed in Xcode 16+
          config.build_settings['OTHER_LDFLAGS'] ||= ['\$(inherited)']
          # Use -weak-l prefix to make these libraries optional
          config.build_settings['OTHER_LDFLAGS'] << '-Wl,-weak-lswiftCompatibility56'
          config.build_settings['OTHER_LDFLAGS'] << '-Wl,-weak-lswiftCompatibilityConcurrency'
          config.build_settings['OTHER_LDFLAGS'] << '-Wl,-weak-lswiftCompatibilityPacks'
          # Suppress linker warnings
          config.build_settings['OTHER_LDFLAGS'] << '-Wl,-w'
        end
        if target.name == 'SegmentAppsFlyeriOSTests'
          config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'YES'
        end
      end
    end
  end
end" > Podfile

