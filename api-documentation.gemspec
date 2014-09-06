require File.expand_path('../lib/documentation/version.rb', __FILE__)

Gem::Specification.new do |s|
  s.name = 'api-documentation'
  s.description = 'Self-Documenting APIs'
  s.version = Documentation::VERSION
  s.authors = ['Sittercity']
  s.email = ['dev@sittercity.com']
  s.homepage = 'http://sittercity.com'
  s.summary = 'Self-Documenting APIs'

  s.files = Dir['lib/**/*.rb']
  s.require_paths = ['lib']

  s.add_runtime_dependency('gherkin', '~> 2.12')
  s.add_runtime_dependency('mustache', '~> 0.99')
  s.add_runtime_dependency('rack-accept_headers', '~> 0.5.0')
end
