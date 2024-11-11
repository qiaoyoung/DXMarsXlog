Pod::Spec.new do |spec|
  spec.name         = "DXMarsXlog"
  spec.version      = "1.0.0"
  spec.summary      = "Tencent's mars-xlog."
  spec.description  = "A wrapper for Tencent's mars-xlog."
  spec.homepage     = "https://github.com/qiaoyoung/DXMarsXlog"
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { "Joe" => "393098486@qq.com" }
  spec.source       = { :git => "https://github.com/qiaoyoung/DXMarsXlog.git", :tag => "#{spec.version}" }
  
  # 平台设置
  spec.platform = :ios, '12.0'
  spec.ios.deployment_target = '12.0'
  
  # 系统依赖
  spec.libraries = ['resolv.9', 'z', 'c++']
  spec.frameworks = ['SystemConfiguration', 'CoreTelephony']
  
  # 源文件设置
  spec.source_files = 'DXMarsXlog/*.{h,m,mm}'
  spec.public_header_files = 'DXMarsXlog/*.h'
  spec.vendored_frameworks = 'DXMarsXlog/mars.framework'
  
  # 编译设置
  spec.pod_target_xcconfig = {
    'VALID_ARCHS[sdk=iphoneos*]' => 'arm64',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 x86_64 i386',
    'ONLY_ACTIVE_ARCH' => 'YES',
    'OTHER_LDFLAGS' => '-lresolv.9 -lz'
  }
  
  spec.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 x86_64 i386'
  }
end
