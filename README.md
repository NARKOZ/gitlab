# Gitlab

[![Build Status](https://img.shields.io/travis/NARKOZ/gitlab.svg?style=flat)](https://travis-ci.org/NARKOZ/gitlab)
[![Code Climate](https://img.shields.io/codeclimate/github/NARKOZ/gitlab.svg?style=flat)](https://codeclimate.com/github/NARKOZ/gitlab)
[![Inline docs](http://inch-ci.org/github/NARKOZ/gitlab.svg?style=flat)](https://inch-ci.org/github/NARKOZ/gitlab)
[![Gem version](https://img.shields.io/gem/v/gitlab.svg?style=flat)](https://rubygems.org/gems/gitlab)
[![License](https://img.shields.io/badge/license-BSD-red.svg?style=flat)](https://github.com/NARKOZ/gitlab/blob/master/LICENSE.txt)

[website](http://narkoz.github.io/gitlab) |
[documentation](http://rubydoc.info/gems/gitlab/frames) |
[gitlab-live](https://github.com/NARKOZ/gitlab-live)

Gitlab is a Ruby wrapper and CLI for the [GitLab API](https://github.com/gitlabhq/gitlabhq/tree/master/doc/api#gitlab-api).

## Installation

Install it from rubygems:

```sh
gem install gitlab
```

Or add to a Gemfile:

```ruby
gem 'gitlab'
# gem 'gitlab', github: 'NARKOZ/gitlab'
```

## Usage

Configuration example:

```ruby
Gitlab.configure do |config|
  config.endpoint       = 'https://example.net/api/v3' # API endpoint URL, default: ENV['GITLAB_API_ENDPOINT']
  config.private_token  = 'qEsq1pt6HJPaNciie3MG'       # user's private token or OAuth2 access token, default: ENV['GITLAB_API_PRIVATE_TOKEN']
  # Optional
  # config.user_agent   = 'Custom User Agent'          # user agent, default: 'Gitlab Ruby Gem [version]'
  # config.sudo         = 'user'                       # username for sudo mode, default: nil
end
```

(Note: If you are using Gitlab.com's hosted service, your endpoint will be `https://gitlab.com/api/v3`)

Usage examples:

```ruby
# set an API endpoint
Gitlab.endpoint = 'http://example.net/api/v3'
# => "http://example.net/api/v3"

# set a user private token
Gitlab.private_token = 'qEsq1pt6HJPaNciie3MG'
# => "qEsq1pt6HJPaNciie3MG"

# configure a proxy server
Gitlab.http_proxy('proxyhost', 8888)
# proxy server w/ basic auth
Gitlab.http_proxy('proxyhost', 8888, 'proxyuser', 'strongpasswordhere')

# list projects
Gitlab.projects(per_page: 5)
# => [#<Gitlab::ObjectifiedHash:0x000000023326e0 @data={"id"=>1, "code"=>"brute", "name"=>"Brute", "description"=>nil, "path"=>"brute", "default_branch"=>nil, "owner"=>#<Gitlab::ObjectifiedHash:0x00000002331600 @data={"id"=>1, "email"=>"john@example.com", "name"=>"John Smith", "blocked"=>false, "created_at"=>"2012-09-17T09:41:56Z"}>, "private"=>true, "issues_enabled"=>true, "merge_requests_enabled"=>true, "wall_enabled"=>true, "wiki_enabled"=>true, "created_at"=>"2012-09-17T09:41:56Z"}>, #<Gitlab::ObjectifiedHash:0x000000023450d8 @data={"id"=>2, "code"=>"mozart", "name"=>"Mozart", "description"=>nil, "path"=>"mozart", "default_branch"=>nil, "owner"=>#<Gitlab::ObjectifiedHash:0x00000002344ca0 @data={"id"=>1, "email"=>"john@example.com", "name"=>"John Smith", "blocked"=>false, "created_at"=>"2012-09-17T09:41:56Z"}>, "private"=>true, "issues_enabled"=>true, "merge_requests_enabled"=>true, "wall_enabled"=>true, "wiki_enabled"=>true, "created_at"=>"2012-09-17T09:41:57Z"}>, #<Gitlab::ObjectifiedHash:0x00000002344958 @data={"id"=>3, "code"=>"gitlab", "name"=>"Gitlab", "description"=>nil, "path"=>"gitlab", "default_branch"=>nil, "owner"=>#<Gitlab::ObjectifiedHash:0x000000023447a0 @data={"id"=>1, "email"=>"john@example.com", "name"=>"John Smith", "blocked"=>false, "created_at"=>"2012-09-17T09:41:56Z"}>, "private"=>true, "issues_enabled"=>true, "merge_requests_enabled"=>true, "wall_enabled"=>true, "wiki_enabled"=>true, "created_at"=>"2012-09-17T09:41:58Z"}>]

# initialize a new client
g = Gitlab.client(endpoint: 'https://api.example.com', private_token: 'qEsq1pt6HJPaNciie3MG')
# => #<Gitlab::Client:0x00000001e62408 @endpoint="https://api.example.com", @private_token="qEsq1pt6HJPaNciie3MG", @user_agent="Gitlab Ruby Gem 2.0.0">

# get a user
user = g.user
# => #<Gitlab::ObjectifiedHash:0x00000002217990 @data={"id"=>1, "email"=>"john@example.com", "name"=>"John Smith", "bio"=>nil, "skype"=>"", "linkedin"=>"", "twitter"=>"john", "dark_scheme"=>false, "theme_id"=>1, "blocked"=>false, "created_at"=>"2012-09-17T09:41:56Z"}>

# get a user's email
user.email
# => "john@example.com"

# set a sudo mode to perform API calls as another user
Gitlab.sudo = 'other_user'
# => "other_user"

# disable a sudo mode
Gitlab.sudo = nil
# => nil
```

For more information, refer to [documentation](http://rubydoc.info/gems/gitlab/frames).

## CLI

Usage examples:

```sh
# list users
gitlab users

# get current user
gitlab user

# get a user
gitlab user 2

# filter output
gitlab user --only=id,username

gitlab user --except=email,bio

# get a user and render result as json
gitlab user 2 --json

# passing options hash to a command (use YAML)
gitlab create_merge_request 4 "New merge request" "{source_branch: 'new_branch', target_branch: 'master', assignee_id: 42}"

```

## CLI Shell

Usage examples:

```sh
# start shell session
gitlab shell

# list available commands
gitlab> help

# list groups
gitlab> groups

# protect a branch
gitlab> protect_branch 1 master

# passing options hash to a command (use YAML)
gitlab> create_merge_request 4 "New merge request" "{source_branch: 'new_branch', target_branch: 'master', assignee_id: 42}"
```

Web version is available at https://gitlab-live.herokuapp.com  
For more information, refer to [website](http://narkoz.github.io/gitlab).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

For more information see [CONTRIBUTING.md](https://github.com/NARKOZ/gitlab/blob/master/CONTRIBUTING.md).

## License

Released under the BSD 2-clause license. See LICENSE.txt for details.
