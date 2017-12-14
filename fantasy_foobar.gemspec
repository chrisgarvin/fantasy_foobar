# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fantasy_foobar/version'

Gem::Specification.new do |spec|
  spec.name          = 'fantasy_foobar'
  spec.version       = FantasyFoobar::VERSION
  spec.authors       = ['Chris Garvin']
  spec.email         = ['chris.garvin@me.com']

  spec.summary       = 'Live console view of your Fantasy Football teams stats'
  spec.homepage      = 'https://www.github.com/chrisgarvin/fantasy_foobar'
  spec.license       = 'MIT'

  spec.files = Dir['lib/**/*.rb', 'lib/fantasy_foobar/data/teams.json']
  spec.bindir        = 'exe'
  spec.executables   = ['fantasy_foobar']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nfl_data', ['~> 0.0.12']
  spec.add_runtime_dependency 'paint'

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
