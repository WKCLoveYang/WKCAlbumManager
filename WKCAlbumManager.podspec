Pod::Spec.new do |s|
s.name         = "WKCAlbumManager"
s.version      = "2.8.5"
s.summary      = "自定义相册数据管理类"
s.homepage     = "https://github.com/WKCLoveYang/WKCAlbumManager.git"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "WKCLoveYang" => "wkcloveyang@gmail.com" }
s.platform     = :ios, "10.0"
s.source       = { :git => "https://github.com/WKCLoveYang/WKCAlbumManager.git", :tag => "2.8.5" }
s.source_files  = "WKCAlbumManager/**/*.{h,m}"
s.public_header_files = "WKCAlbumManager/**/*.h"
s.frameworks = "Foundation", "UIKit", "Photos"
s.requires_arc = true

end
