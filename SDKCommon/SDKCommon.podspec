Pod::Spec.new do |spec|
  spec.name          = 'SDKCommon'
  spec.version       = '1.0'
  spec.summary       = 'SDK for netowork requests'
  
  spec.homepage      = 'https://github.com/andradedev/iBeer'
  spec.license       = { :type => 'MIT', :file => 'LICENSE'}
  spec.author        = { 'Felipe Andrade' => 'andrade.mct@gmail.com' }
  spec.source        = { :git => 'https://github.com/andradedev/iBeer.git', :tag => 'v' }
  
  spec.swift_version = '5.3.3'
  spec.ios.deployment_target  = '13.0'
  
  spec.source_files  = 'SDKCommon/*.swift'
end
