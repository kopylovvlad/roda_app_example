# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.1'
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bcrypt'
gem 'cuba'
gem 'dotenv'
gem 'mongoid'
gem 'puma', '~> 3.0'
gem 'simplecov'

group :test do
  gem 'rspec'
  gem 'database_cleaner-mongoid', git: 'https://github.com/DatabaseCleaner/database_cleaner-mongoid'
end
