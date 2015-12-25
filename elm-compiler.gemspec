# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elm/compiler/version'

Gem::Specification.new do |spec|
  spec.name          = 'elm-compiler'
  spec.version       = Elm::Compiler::VERSION
  spec.authors       = ['Frank Bonetti']
  spec.email         = ['frank.r.bonetti@gmail.com']

  spec.summary       = 'Ruby wrapper for the Elm compiler'
  spec.description   = 'Allows you compile Elm files and write to a file or stdout'
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.35.1'
end
