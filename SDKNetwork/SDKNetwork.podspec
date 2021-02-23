Pod::Spec.new do |spec|
  spec.name          = 'SDKNetwork'
  spec.version       = '1.0'
  spec.summary       = 'SDK for netowork requests'
  spec.homepage      = 'https://www.google.com'
  spec.license       = { :type => 'MIT', :file => 'LICENSE'}
  
  spec.authors       = { 'Felipe Andrade' => 'andrade.mct@gmail.com' }
  spec.source        = { :git => 'https://google.com', :tag => 'v' }
  spec.swift_version = '11.0'

  spec.ios.deployment_target  = '11.0'

  spec.source_files       = 'SDKNetwork/*.swift'
end
