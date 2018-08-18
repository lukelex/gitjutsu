# frozen_string_literal: true

source "https://rubygems.org"
ruby "2.5.1"

gem "closed_struct"
gem "dotenv-rails"
gem "pg", "~> 0.18"
gem "puma", "~> 3.0"
gem "rails", "~> 5.2.1"
gem "slim"

# Service integration
gem "octokit"
gem "omniauth-github"

# Cache & Queueing
gem "redis-rails", "~> 5.0"
gem "resque", "~> 1.27"

# Frontend tools
gem "bootstrap-sass", "~> 3.3"
gem "font-awesome-rails", "~> 4.7"
gem "jquery-rails", "~> 4.3"
gem "sass-rails", "~> 5.0"
gem "turbolinks", "~> 5"
gem "uglifier", ">= 1.3.0"

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
  gem "bootsnap", require: false
end
