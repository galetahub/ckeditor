# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

gem 'rails', '~> 7.2'

platforms :ruby do
  gem 'sass'
  gem 'sassc'
  gem 'sprockets-rails'
  gem 'sqlite3'

  group :development, :test do
    gem 'capybara'
    gem 'rubocop-rails'
  end

  group :active_record do
    gem 'carrierwave'
    gem 'dragonfly'
    gem 'mini_magick'
    # gem 'paperclip', '~> 6.1.0'
  end

  group :mongoid do
    gem 'carrierwave-mongoid', require: 'carrierwave/mongoid'
    gem 'mongoid'
    # gem 'mongoid-paperclip', require: 'mongoid_paperclip'
    gem 'image_processing'
    gem 'shrine'
    gem 'shrine-mongoid'
  end
end
