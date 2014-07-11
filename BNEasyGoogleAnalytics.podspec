#
# Be sure to run `pod lib lint BNEasyGoogleAnalytics.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "BNEasyGoogleAnalytics"
  s.version          = "0.1.0"
  s.summary          = "An objective-c wrapper for Google's Analytics API, with a more fluent interface"
  s.description      = <<-DESC
                       BNEasyGoogleAnalytics is a wrapper around the default GoogleAnalytics iOS SDK, providing
                       a slightly restricted subset of the features it offers with a much more native interface.
                       Say goodbye to GAIDictionaryBuilder, and hello to an analytics interface that feels like
                       it was actually written by a developer who had used Objective-C before.
                       DESC
  s.homepage         = "https://github.com/brandnetworks/BNEasyGoogleAnalytics"
  s.license          = 'apache 2'
  s.author           = { "Ben Nicholas" => "bn@bn.co" }
  s.source           = { :git => "https://github.com/brandnetworks/BNEasyGoogleAnalytics.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/brandnetworks'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resources = 'Pod/Assets/*.png'

  s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'GoogleAnalytics-iOS-SDK', '~> 3.0'
end
