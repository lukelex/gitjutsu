# frozen_string_literal: true

source "https://rubygems.org"
ruby "2.4.4"

gem "pg", "~> 0.18"
gem "puma", "~> 3.0"
gem "rails", "~> 5.1.1"
gem "redis-rails", "~> 5.0"

gem "bootstrap-sass", "~> 3.3"
gem "font-awesome-rails", "~> 4.7"
gem "jquery-rails", "~> 4.3"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"

gem "turbolinks", "~> 5"
# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 3.0"

gem "dotenv-rails"
gem "octokit"
gem "omniauth-github"
gem "resque", "~> 1.27"
gem "slim"

gem "closed_struct"

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "pry", require: false
  gem "rb-readline", require: false
  gem "rspec-rails", "~> 3.5"
  gem "rubocop", require: false
end

group :development do
  gem "guard", require: false
  gem "guard-rspec", require: false
end
