#YPAlertView.podspec
Pod::Spec.new do |s|
s.name         = "YPAlertView"
s.version      = "1.0.4"
s.summary      = "一个可高度自定义的alert view."

s.homepage     = "https://github.com/yuping1989/YPAlertView"
s.license      = 'MIT'
s.author       = { "Ping Yu" => "290180695@qq.com" }
s.platform     = :ios, "7.0"
s.ios.deployment_target = "7.0"
s.source       = { :git => "https://github.com/yuping1989/YPAlertView.git", :tag => s.version}
s.source_files  = 'YPAlertView/YPAlertView/**/*.{h,m}'
s.dependency 'Masonry'
s.requires_arc = true
end
