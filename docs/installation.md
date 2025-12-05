<!-- THIS DOCUMENT IS PUBLISHED ON https://narkoz.github.io/gitlab -->
# Installation

## Rubygems

Install the latest version of the gem by running the following command

```sh
gem install gitlab
```

## Bundler

Install the latest version of the gem by adding the following line to your Gemfile

```rb
gem 'gitlab'
```

and running

```sh
bundle install
```

You can also point directly to the git repository to install it from the latest
GitHub source

```rb
gem 'gitlab', github: 'NARKOZ/gitlab'
```

## Manual build

If you want to build the gem from source manually

```sh
git clone https://github.com/NARKOZ/gitlab.git
cd gitlab
gem build gitlab.gemspec
```
