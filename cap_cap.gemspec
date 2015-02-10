# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cap_cap/version'

Gem::Specification.new do |spec|
  spec.name          = "cap_cap"
  spec.version       = CapCap::VERSION
  spec.authors       = ["Koji NAKAMURA"]
  spec.email         = ["kozy4324@gmail.com"]
  spec.summary       = %q{(Cap)ture web pages by using (Cap)ybara and Poltergeist.}
  spec.description   = %q{(Cap)ture web pages by using (Cap)ybara and Poltergeist.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capybara", "~> 2.4"
  spec.add_dependency "poltergeist", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
