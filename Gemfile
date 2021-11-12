# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

gem 'rails', '~> 5.2.4.6'

platforms :ruby do
  gem 'sass'
  gem 'sqlite3', '~> 1.3.6'
  gem 'sprockets', '~> 3.7.2'

  group :development, :test do
    gem 'capybara', '>= 0.4.0'
    gem 'jquery-rails', '~> 4.3.3'
    gem 'mynyml-redgreen', '~> 0.7.1', require: 'redgreen'
    gem 'rails-controller-testing'

    gem 'rubocop-rails'
  end

  group :active_record do
    gem 'carrierwave'
    gem 'dragonfly'
    gem 'mini_magick'
    gem 'paperclip', '~> 6.1.0'
  end

  group :mongoid do
    gem 'bson_ext'
    gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
    gem 'mongoid', '~> 7.0.2'
    gem 'mongoid-paperclip', require: 'mongoid_paperclip'
    gem 'shrine'
    gem 'shrine-mongoid'
    gem 'image_processing'
  end
end
