# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

abstract_target 'Shared' do
  # use_frameworks!
  use_modular_headers!
  
  pod 'GoogleAds-IMA-iOS-SDK', '~> 3.14'
  
  target 'VoltaxDemo-Dev'
  
  abstract_target 'DemoApps' do
    
    pod 'VoltaxSDK', "=1.2.1"

    target 'VoltaxDemo'

  end
end
