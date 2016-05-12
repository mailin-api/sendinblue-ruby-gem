# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sendinblue/version'

Gem::Specification.new do |spec|
  spec.name          = "sendinblue"
  spec.version       = Sendinblue::VERSION
  spec.date          = "2016-05-12"
  spec.authors       = ["SendinBlue Developers"]
  spec.email         = ["contact@sendinblue.com"]

  spec.summary       = %q{Official SendinBlue API V2 Ruby GEM}
  spec.description   = %q{This is official SendinBlue provided API V2 Ruby GEM. It implements the various exposed APIs that you can read more about on https://apidocs.sendinblue.com.}
  spec.homepage      = "https://www.sendinblue.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.post_install_message = "Thanks for installing!"

  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
