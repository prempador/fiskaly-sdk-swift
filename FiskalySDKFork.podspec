Pod::Spec.new do |spec|

  spec.name         = "FiskalySDKFork"
  spec.version      = "1.2.000"
  spec.summary      = "FiskalySDK helps integrators with working with the fiskaly Client."
  spec.description  = <<-DESC
                    This is a default description of the iOS SDK provided by fiskaly. This is a fork. 
                   DESC

  spec.homepage     = "https://developer.fiskaly.com/"
  spec.license      = { :type => "MIT", :file => "license.txt" }
  spec.author             = { "prempador" => "muellner.benjamin@gmail.com" }
  spec.platform     = :ios, "9.0"
  spec.source         = { :http => "https://github.com/prempador/fiskaly-sdk-swift/releases/download/v#{spec.version}/FiskalySDK.zip" }
  spec.ios.vendored_frameworks = "FiskalySDK.framework"

end
