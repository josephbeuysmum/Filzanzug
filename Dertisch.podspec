Pod::Spec.new do |s|
  s.name            = "Dertisch"
  s.version         = "0.2.2"
  s.summary         = "A lightweight framework for Swift apps."
  s.description     = <<-DESC
  Dertisch is a lightweight framework for Swift built around dependency injection
  DESC
  s.homepage        = "http://josephbeuysmum.co.uk"
  s.license         = "MIT"
  s.author          = {"Richard Willis" => "richard@josephbeuysmum.co.uk"}
  s.platform        = :ios, "10.0"
  s.source          = {:git => "https://github.com/josephbeuysmum/Dertisch.git", :tag => "#{s.version}"}
  s.source_files    = "Dertisch/**/*.{h,m,swift}"
  s.swift_version   = "4.2"
end
