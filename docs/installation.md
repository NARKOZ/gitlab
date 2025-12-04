# Installation

## Rubygems

Install the latest version of gem by running following command

```sh
gem install gitlab
```

## Bundler

Install the latest version of gem by adding following line to Gemfile

```rb
gem 'gitlab'
```

and running

```sh
bundle install
```

You can also point directly to git repository to install it from the latest
GitHub source

```rb
gem 'gitlab', github: 'NARKOZ/gitlab'
```

## Manual build

If you want to build gem from source manually

```sh
git clone https://github.com/NARKOZ/gitlab.git
cd gitlab
gem build gitlab.gemspec
```
