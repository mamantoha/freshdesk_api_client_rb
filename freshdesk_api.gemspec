# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'freshdesk_api/version'

Gem::Specification.new do |spec|
  spec.name          = "freshdesk_api"
  spec.version       = FreshdeskAPI::VERSION
  spec.authors       = ["Anton Maminov"]
  spec.email         = ["anton.linux@gmail.com"]

  spec.summary       = %q{Freshdesk REST API Client}
  spec.description   = %q{Ruby wrapper for the REST API at http://freshdesk.com. Documentation at http://freshdesk.com/api.}
  spec.homepage      = "https://github.com/mamantoha/freshdesk_api_client_rb"

  spec.required_ruby_version     = ">= 2.0.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport"
  spec.add_runtime_dependency "rest-client"
  spec.add_runtime_dependency "multi_json"
  spec.add_runtime_dependency "deep_merge"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
end
