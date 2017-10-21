lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlab/version'

Gem::Specification.new do |gem|
  gem.name          = 'gitlab'
  gem.version       = Gitlab::VERSION
  gem.authors       = ['Nihad Abbasov']
  gem.email         = ['mail@narkoz.me']
  gem.description   = 'Ruby client and CLI for GitLab API'
  gem.summary       = 'A Ruby wrapper and CLI for the GitLab API'
  gem.homepage      = 'https://github.com/narkoz/gitlab'

  gem.files         = `git ls-files`.split($/)
  gem.bindir        = 'exe'
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.license       = 'BSD'

  gem.required_ruby_version = '>= 2.0.0'

  gem.add_runtime_dependency 'httparty'
  gem.add_runtime_dependency 'terminal-table'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'rubocop'
end
