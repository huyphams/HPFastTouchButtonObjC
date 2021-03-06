Pod::Spec.new do |s|

  s.name         = "HPFastTouchButtonObjC"
  s.version      = "1.1.0"
  s.summary      = "Resolve problem Passing touch info from button to super view"
  s.homepage     = "http://facebook.com/huyphams"
  s.license      = "MIT"
  s.author             = { "Huy Pham" => "duchuykun@gmail.com" }
  s.social_media_url   = "https://facebook.com/huyphams"
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/huyphams/HPFastTouchButtonObjC.git", :tag => "#{s.version}" }
  s.source_files = 'Classes/*.{h,m}'
  s.requires_arc = true

end
