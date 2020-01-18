swift_version = File.new('.swift-version').read

Pod::Spec.new do |s|
  s.name         = "AudioKnigiSite"
  s.version      = "1.0.5"
  s.summary      = "Framework for playing media from AudioKnigi.Com"
  s.description  = "Framework for playing media from AudioKnigi.Com."

  s.homepage     = "https://github.com/shvets/AudioKnigiSite"
  s.authors = { "Alexander Shvets" => "alexander.shvets@gmail.com" }
  s.license      = "MIT"

  s.ios.deployment_target = "12.2"
  #s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "12.2"
  #s.watchos.deployment_target = "2.0"

  s.source = { :git => "https://github.com/shvets/AudioKnigiSite.git", :tag => s.version }
  s.source_files = "Sources/**/*.swift"

  s.resource_bundles = {
    'com.rubikon.AudioKnigiSite' => ['Sources/**/*.{storyboard,strings,lproj,json}', ]
  }

  s.dependency 'MediaApis', '~> 1.0.0'
  s.dependency 'Runglish', '~> 1.0.0'
  s.dependency 'AudioPlayer', '~> 1.0.16'
  s.dependency 'TVSetKit', '~> 1.0.27'
  s.dependency 'Files', '~> 2.0.1'

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => swift_version }
end
