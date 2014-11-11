Pod::Spec.new do |s|
  s.name         = 'DAZABTest'
  s.version      = '1.0.0'
  s.summary      = 'A simple ABTest framework with a synchronous API'
  s.homepage     = 'https://www.github.com/dasmer/DAZABTest'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Dasmer Singh' => 'dasmersingh@gmail.com'}
  s.source       = { :git => 'https://github.com/dasmer/DAZABTest.git', :tag => "v#{s.version}"}
  s.source_files = 'DAZABTest/*.{h,m}'
  s.platform     = :ios, '6.0'
  s.requires_arc = true
end