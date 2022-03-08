# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in feedproxy.gemspec
gemspec

gem "rake", "~> 13.0"

gem "rspec", "~> 3.0"

gem "rubocop", "~> 1.21"

gem "sinatra"

gem "httparty"

gem "nokogiri"

group :development do
  gem "guard"
  gem "guard-bundler", require: false
  gem "guard-rspec", require: false
  gem "solargraph"
end

group :test do
  gem "vcr"
  gem "webmock"
end
