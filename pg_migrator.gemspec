# coding: utf-8

Gem::Specification.new do |s|
  s.name          = 'pg_migrator'
  s.version       = '1.0.2'
  s.author        = 'Pierre BAZONNARD'
  s.email         = ['pierre.bazonnard@gmail.com']
  s.homepage      = 'https://github.com/pyer/pg_migrator'
  s.summary       = 'Migrate Postgres databases'
  s.description   = 'This tool provides a set of Rake tasks to apply changes on different Postgres environments.'
  s.license       = 'MIT'
  s.files         = Dir['lib/*.rb'] + Dir['tasks/*.rake'] + ['Rakefile', 'LICENSE', 'README.md', __FILE__]
  s.require_paths = %w(lib tasks)
  s.required_ruby_version = '~> 2'

  s.add_dependency 'rake', '~> 10'
  s.add_dependency 'pg', '~> 0'
  s.add_dependency 'pyer-properties', '~> 1'
  s.add_development_dependency 'minitest', '~> 5'

  s.requirements  = 'Postgres'
end
