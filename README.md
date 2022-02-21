# Gitlab

[![Build Status](https://img.shields.io/github/workflow/status/NARKOZ/gitlab/CI/master)](https://github.com/NARKOZ/gitlab/actions/workflows/ci.yml)
[![Gem version](https://img.shields.io/gem/v/gitlab.svg)](https://rubygems.org/gems/gitlab)
[![License](https://img.shields.io/badge/license-BSD-red.svg)](https://github.com/NARKOZ/gitlab/blob/master/LICENSE.txt)

[website](https://narkoz.github.io/gitlab) |
[documentation](https://www.rubydoc.info/gems/gitlab/frames) |
[gitlab-live](https://github.com/NARKOZ/gitlab-live)

Gitlab is a Ruby wrapper and CLI for the [GitLab API](https://docs.gitlab.com/ee/api/index.html).

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

Mac OS users can install using Homebrew (may not be the latest version):

```sh
brew install gitlab-gem
```

## Usage

Configuration example:

```ruby
Gitlab.configure do |config|
  config.endpoint       = 'https://example.net/api/v4' # API endpoint URL, default: ENV['GITLAB_API_ENDPOINT'] and falls back to ENV['CI_API_V4_URL']
  config.private_token  = 'qEsq1pt6HJPaNciie3MG'       # user's private token or OAuth2 access token, default: ENV['GITLAB_API_PRIVATE_TOKEN']
  # Optional
  # config.user_agent   = 'Custom User Agent'          # user agent, default: 'Gitlab Ruby Gem [version]'
  # config.sudo         = 'user'                       # username for sudo mode, default: nil
end
```

(Note: If you are using GitLab.com's hosted service, your endpoint will be `https://gitlab.com/api/v4`)

Usage examples:

```ruby
# set an API endpoint
Gitlab.endpoint = 'https://example.net/api/v4'
# => "https://example.net/api/v4"

# set a user private token
Gitlab.private_token = 'qEsq1pt6HJPaNciie3MG'
# => "qEsq1pt6HJPaNciie3MG"

# configure a proxy server
Gitlab.http_proxy('proxyhost', 8888)
# proxy server with basic auth
Gitlab.http_proxy('proxyhost', 8888, 'proxyuser', 'strongpasswordhere')
# set timeout for responses
ENV['GITLAB_API_HTTPARTY_OPTIONS'] = '{read_timeout: 60}'

# list projects
Gitlab.projects(per_page: 5)
# => [#<Gitlab::ObjectifiedHash:0x000000023326e0 @data={"id"=>1, "code"=>"brute", "name"=>"Brute", "description"=>nil, "path"=>"brute", "default_branch"=>nil, "owner"=>#<Gitlab::ObjectifiedHash:0x00000002331600 @data={"id"=>1, "email"=>"john@example.com", "name"=>"John Smith", "blocked"=>false, "created_at"=>"2012-09-17T09:41:56Z"}>, "private"=>true, "issues_enabled"=>true, "merge_requests_enabled"=>true, "wall_enabled"=>true, "wiki_enabled"=>true, "created_at"=>"2012-09-17T09:41:56Z"}>, #<Gitlab::ObjectifiedHash:0x000000023450d8 @data={"id"=>2, "code"=>"mozart", "name"=>"Mozart", "description"=>nil, "path"=>"mozart", "default_branch"=>nil, "owner"=>#<Gitlab::ObjectifiedHash:0x00000002344ca0 @data={"id"=>1, "email"=>"john@example.com", "name"=>"John Smith", "blocked"=>false, "created_at"=>"2012-09-17T09:41:56Z"}>, "private"=>true, "issues_enabled"=>true, "merge_requests_enabled"=>true, "wall_enabled"=>true, "wiki_enabled"=>true, "created_at"=>"2012-09-17T09:41:57Z"}>, #<Gitlab::ObjectifiedHash:0x00000002344958 @data={"id"=>3, "code"=>"gitlab", "name"=>"Gitlab", "description"=>nil, "path"=>"gitlab", "default_branch"=>nil, "owner"=>#<Gitlab::ObjectifiedHash:0x000000023447a0 @data={"id"=>1, "email"=>"john@example.com", "name"=>"John Smith", "blocked"=>false, "created_at"=>"2012-09-17T09:41:56Z"}>, "private"=>true, "issues_enabled"=>true, "merge_requests_enabled"=>true, "wall_enabled"=>true, "wiki_enabled"=>true, "created_at"=>"2012-09-17T09:41:58Z"}>]

# initialize a new client with custom headers
g = Gitlab.client(
  endpoint: 'https://example.com/api/v4',
  private_token: 'qEsq1pt6HJPaNciie3MG',
  httparty: {
    headers: { 'Cookie' => 'gitlab_canary=true' }
  }
)
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

# set the private token to an empty string to make unauthenticated API requests
Gitlab.private_token = ''
# => ""

# a paginated response
projects = Gitlab.projects(per_page: 5)

# check existence of the next page
projects.has_next_page?

# retrieve the next page
projects.next_page

# iterate all projects
projects.auto_paginate do |project|
  # do something
end

# retrieve all projects as an array
projects.auto_paginate
```

For more information, refer to [documentation](https://www.rubydoc.info/gems/gitlab/frames).

## CLI

It is possible to use this gem as a command line interface to GitLab. In order to make that work you need to set a few environment variables:
```sh
export GITLAB_API_ENDPOINT=https://gitlab.example.com/api/v4
export GITLAB_API_PRIVATE_TOKEN=<your private token from /profile/personal_access_tokens>

# This one is optional and can be used to set any HTTParty option you may need
# using YAML hash syntax. For example, this is how you would disable SSL
# verification (useful if using a self-signed cert).
export GITLAB_API_HTTPARTY_OPTIONS="{verify: false}"
```

Usage:

When you want to know which CLI commands are supported, take a look at the client [commands implemented in this gem](https://www.rubydoc.info/gems/gitlab/4.18.0/Gitlab/Client). Any of those methods can be called as a command by passing the parameters of the commands as parameters of the CLI.

Usage examples:

```sh
# list users
# see: https://www.rubydoc.info/gems/gitlab/Gitlab/Client/Users#users-instance_method
gitlab users

# get current user
# see: https://www.rubydoc.info/gems/gitlab/Gitlab/Client/Users#user-instance_method
gitlab user

# get a user
# see: https://www.rubydoc.info/gems/gitlab/Gitlab/Client/Users#user-instance_method
gitlab user 2

# filter output
gitlab user --only=id,username

gitlab user --except=email,bio

# get a user and render result as json
gitlab user 2 --json

# passing options hash to a command (use YAML)
# see: https://www.rubydoc.info/gems/gitlab/Gitlab/Client/MergeRequests#create_merge_request-instance_method
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
For more information, refer to [website](https://narkoz.github.io/gitlab).

## Development

### With a dockerized GitLab instance

```shell
docker-compose up -d gitlab # Will start the GitLab instance in the background (approx. 3 minutes)
```

After a while, your GitLab instance will be accessible on http://localhost:3000.

Once you have set your new root password, you can login with the root user.

You can now setup a personal access token here: http://localhost:3000/profile/personal_access_tokens

Once you have your token, set the variables to the correct values in the `docker.env` file.

Then, launch the tool:

```shell
docker-compose run app
```

```ruby
Gitlab.users
=> [#<Gitlab::ObjectifiedHash:47231290771040 {hash: {"id"=>1, "name"=>"Administrator", "username"=>"root", ...]
```

To launch the specs:

```shell
docker-compose run app rake spec
```

#### Want to use GitLab Enterprise?

Just change the image from `gitlab/gitlab-ce:latest` to `gitlab/gitlab-ee:latest` in the `docker-compose.yml` file.

### With an external GitLab instance

First, set the variables to the correct values in the `docker.env` file.

Then, launch the tool:

```shell
docker-compose run app
```

```ruby
Gitlab.users
=> [#<Gitlab::ObjectifiedHash:47231290771040 {hash: {"id"=>1, "name"=>"Administrator", "username"=>"root", ...]
```

To launch the specs,

```shell
docker-compose run app rake spec
```

### Without Docker

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

For more information see [CONTRIBUTING.md](https://github.com/NARKOZ/gitlab/blob/master/CONTRIBUTING.md).

## License

Released under the BSD 2-clause license. See LICENSE.txt for details.
