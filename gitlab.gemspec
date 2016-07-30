# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlab/version'

Gem::Specification.new do |gem|
  gem.name          = "gitlab"
  gem.version       = Gitlab::VERSION
  gem.authors       = ["Nihad Abbasov"]
  gem.email         = ["mail@narkoz.me"]
  gem.description   = %q{Ruby client and CLI for GitLab API}
  gem.summary       = %q{A Ruby wrapper and CLI for the GitLab API}
  gem.homepage      = "https://github.com/narkoz/gitlab"

  gem.files         = `git ls-files`.split($/)
  gem.bindir        = "exe"
  gem.executables   = gem.files.grep(%r{^exe/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.license       = "BSD"

  if RUBY_VERSION < '2.0'
    gem.add_runtime_dependency 'httparty', '~> 0.13.0'
  else
    gem.add_runtime_dependency 'httparty'
  end
  gem.add_runtime_dependency 'terminal-table'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'webmock'
end
