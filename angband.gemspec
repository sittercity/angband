require File.expand_path('../lib/angband/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name = 'angband'
  s.license = 'ISC'
  s.version = Angband::VERSION
  s.authors = ['Sittercity']
  s.email = ['dev@sittercity.com']
  s.homepage = 'http://sittercity.com'
  s.summary = 'Self-Documenting APIs for Rack applications'

  s.files = Dir['lib/**/*']
  s.require_paths = ['lib']

  s.add_runtime_dependency('gherkin', '~> 2.12')
  s.add_runtime_dependency('mustache', '~> 0.99')
  s.add_runtime_dependency('rack-accept_headers', '~> 0.5.0')
end
