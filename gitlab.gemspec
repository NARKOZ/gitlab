# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlab/version'

Gem::Specification.new do |gem|
  gem.name          = 'gitlab'
  gem.version       = Gitlab::VERSION
  gem.authors       = ['Nihad Abbasov', 'Sean Edge']
  gem.email         = ['nihad@42na.in', 'asedge@gmail.com']
  gem.description   = 'Ruby client and CLI for GitLab API'
  gem.summary       = 'A Ruby wrapper and CLI for the GitLab API'
  gem.homepage      = 'https://github.com/NARKOZ/gitlab'

  gem.files         = Dir['{exe,lib}/**/*', 'LICENSE.txt', 'README.md', 'CHANGELOG.md']
  gem.bindir        = 'exe'
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.license       = 'BSD-2-Clause'

  gem.required_ruby_version = '>= 2.3'

  gem.add_runtime_dependency 'httparty', '~> 0.14', '>= 0.14.0'
  gem.add_runtime_dependency 'terminal-table', '~> 1.5', '>= 1.5.1'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rubocop'
  gem.add_development_dependency 'webmock'
end
