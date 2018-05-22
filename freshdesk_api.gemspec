
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'freshdesk_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'freshdesk_api'
  spec.version       = FreshdeskAPI::VERSION
  spec.authors       = ['Anton Maminov']
  spec.email         = ['anton.linux@gmail.com']

  spec.summary       = 'Freshdesk REST API Client'
  spec.description   = 'Ruby wrapper for the REST API at http://freshdesk.com. Documentation at http://freshdesk.com/api.'
  spec.homepage      = 'https://github.com/mamantoha/freshdesk_api_client_rb'

  spec.required_ruby_version = '>= 2.4.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport'
  spec.add_runtime_dependency 'deep_merge'
  spec.add_runtime_dependency 'multi_json'
  spec.add_runtime_dependency 'rest-client'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'webmock'
end
