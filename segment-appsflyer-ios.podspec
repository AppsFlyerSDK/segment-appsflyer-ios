Pod::Spec.new do |s|
  s.name             = "segment-appsflyer-ios"
  s.version          = "1.1.2"
  s.summary            = "AppsFlyer Integration for Segment's analytics-ios library."
  s.description      = <<-DESC
    AppsFlyer is the market leader in mobile advertising attribution & analytics, helping marketers to pinpoint their targeting, optimize their ad spend and boost their ROI.
DESC

  s.homepage         = "https://github.com/AppsFlyerSDK/segment-appsflyer-ios"
  s.license          = 'MIT'
  s.author           = { "Golan" => "golan@appsflyer.com" }
  s.source           = { :git => "https://github.com/AppsFlyerSDK/segment-appsflyer-ios.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/Appsflyer'

  s.ios.deployment_target = '8.0'

  s.source_files = 'segment-appsflyer-ios/Classes/**/*'
  
  s.dependency 'Analytics', '~> 3.1'
  s.dependency 'AppsFlyerFramework', '~> 4.5'
  s.preserve_paths      = 'AppsFlyer.framework'
  s.public_header_files = 'AppsFlyer.framework/Versions/A/Headers'
  s.vendored_frameworks = 'AppsFlyer.framework'

end
