Pod::Spec.new do |s|
  s.name         = "PeakSwipeCell"
  s.version      = "0.0.1"
  s.summary      = "支持左右划动的TableViewCell，可以显示一个菜单，并支持划动图像跟随."
  s.homepage     = "https://github.com/conis/PeakSwipeCell"
  s.license      = 'MIT'
  s.author       = { "Conis" => "conis.yi@gmail.com" }
  s.source       = { :git => "https://github.com/conis/PeakSwipeCell.git", :branch => "master"}
  s.platform     = :ios, '5.0'
  s.source_files = 'PeakSwipeCell/*.{h,m}'
  s.framework  = 'UIKit'
  s.requires_arc = true
end
