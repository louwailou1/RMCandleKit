
Pod::Spec.new do |s|
  s.name         = "RMCandleKit"
  s.version      = "1.2"
  s.summary      = "RMCandleKit."
  s.description  = <<-DESC
                    this is RMCandleKit
                   DESC
  s.homepage     = "https://gitlab.com/RMCandleKit"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "RMCandleKit" => "RMCandleKit@msn.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://gitlab.com/RMCandleKit.git", :tag => s.version.to_s }
  s.source_files  = "RMCandleKit/RMCandleKit/**/*.{h,m,swift,xib,storyboard}"
  s.requires_arc = true
    s.dependency "Masonry"
end
