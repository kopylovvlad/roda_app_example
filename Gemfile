# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.1'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bcrypt'
gem 'dotenv'
gem 'encryption'
gem 'faker', git: 'https://github.com/stympy/faker.git', branch: 'master'
gem 'kaminari-core'
gem 'kaminari-mongoid'
gem 'mongoid'
gem 'puma', '~> 3.0'
gem 'rack'
gem 'rack-test'
gem 'roda'
gem 'roda-route_list'
gem 'simplecov'
gem 'swagger-blocks'
gem 'swaggerui_local'
gem 'warden'

group :development do
  gem 'pry'
  # gem 'rubocop'
  gem 'solargraph'
end

group :test do
  gem 'database_cleaner'
  gem 'database_cleaner-mongoid', git: 'https://github.com/DatabaseCleaner/database_cleaner-mongoid'
  gem 'factory_bot'
  gem 'rspec'
end
