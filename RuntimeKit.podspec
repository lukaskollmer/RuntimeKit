#
# Be sure to run `pod lib lint RuntimeKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RuntimeKit'
  s.version          = '0.1.0'
  s.summary          = 'Swift wrapper around the Objective-C runtime APIs'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  RuntimeKit is a Swift library for accessing the Objective-C runtime.
  In addition to providing wrappers around features like method swizzling or associated values, it also provides some type safety.

  As of right now, RuntimeKit only supports method swizzling, replacing a methods implementation with a block and setting associated objects. More features will be added over time.
                       DESC

  s.homepage         = 'https://github.com/lukaskollmer/RuntimeKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'License' }
  s.author           = { 'lukaskollmer' => 'lukas.kollmer@gmail.com' }
  s.source           = { :git => 'https://github.com/lukaskollmer/RuntimeKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'RuntimeKit/Sources/**/*'

  # s.resource_bundles = {
  #   'RuntimeKit' => ['RuntimeKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
