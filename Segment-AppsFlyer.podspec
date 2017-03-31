Pod::Spec.new do |s|
  s.name             = "Segment-AppsFlyer"
  s.version          = "1.1.11"
  s.summary          = "AppsFlyer Integration for Segment's analytics-ios library."

  s.description      = <<-DESC
                       Analytics for iOS provides a single API that lets you
                       integrate with over 100s of tools.
                       This is the AppsFlyer integration for the iOS library.
                       DESC

  s.homepage         = "http://segment.com/"
  s.license          =  { :type => 'MIT' }
  s.author           = { "Segment" => "friends@segment.com" }
  s.source           = { :git => "https://github.com/AppsFlyerSDK/segment-appsflyer-ios.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/segment'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'segment-appsflyer-ios/Classes/**/*'

  s.dependency 'AppsFlyerFramework', '~> 4'
  s.dependency 'Analytics', '~> 3.5'
end
