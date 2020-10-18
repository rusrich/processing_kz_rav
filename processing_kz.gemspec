# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'processing_kz_rav/version'

Gem::Specification.new do |spec|
  spec.name          = 'processing_kz_rav'
  spec.version       = ProcessingKzRav::VERSION
  spec.authors       = ['Pavel Tkachenko']
  spec.email         = ['tpepost@gmail.com']
  spec.summary       = 'Integrate with processing.kz easily'
  spec.description   = 'Helps to integrate with processing.kz without pain. Merchant ID is required for work.'
  spec.homepage      = 'https://processing.kz'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency 'geckodriver-helper'

  spec.add_runtime_dependency 'savon'
end
