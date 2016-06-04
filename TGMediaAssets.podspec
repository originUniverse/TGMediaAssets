Pod::Spec.new do |spec|
  spec.name         = "TGMediaAssets"
  spec.version      = "1.0.1"
  spec.authors      = { "Herui" => "heruicross@gmail.com" }
  spec.homepage     = "https://github.com/red3/TGMediaAssets"
  spec.summary      = "TGMediaAssets, idea from telegram"
  spec.source       = { :git => "https://github.com/red3/TGMediaAssets.git", :tag => spec.version.to_s }
  spec.license      = { :type => "GNU", :file => "LICENSE" }
  spec.platform = :ios, '7.0'
  spec.source_files = "TGMediaAssets/*"

  spec.requires_arc = true
  
  spec.ios.deployment_target = '7.0'
  spec.dependency "SSignalKit", "~> 0.0.2"
  spec.ios.frameworks = ['UIKit', 'Foundation', 'Accelerate'] 
  spec.libraries = 'c++'
end
