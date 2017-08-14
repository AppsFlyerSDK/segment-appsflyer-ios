Pod::Spec.new do |s|
  s.name             = "segment-appsflyer-ios"
  s.version          = "1.2.1"
  s.summary          = "AppsFlyer Integration for Segment's analytics-ios library."

  s.description      = <<-DESC
                       AppsFlyer is the market leader in mobile advertising attribution & analytics, helping marketers to pinpoint their targeting, optimize their ad spend and boost their ROI.
                       DESC

  s.homepage         = "https://github.com/AppsFlyerSDK/segment-appsflyer-ios"
  s.license          =  { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Appsflyer" => "maxim@appsflyer.com" }
  s.source           = { :git => "https://github.com/AppsFlyerSDK/segment-appsflyer-ios.git", :tag => s.version.to_s }
  

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.dependency 'Analytics', '~> 3.5'
  s.source_files = 'segment-appsflyer-ios/Classes/**/*'
  s.dependency 'AppsFlyerFramework', '~> 4'    


  s.subspec 'StaticLibWorkaround' do |workaround|
    # For users who are unable to bundle static libraries as dependencies
    # you can choose this subspec, but be sure to include the following in your Podfile:
    # pod 'AppsFlyerFramework','~> 4'
    # Please manually add the following file preserved by Cocoapods to your xcodeproj file
    workaround.preserve_paths = 'segment-appsflyer-ios/Classes/**/*'
  end
end