# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

gem 'rails', '~> 6.1'

platforms :ruby do
  gem 'sass'
  gem 'sqlite3'
  gem 'sprockets-rails'
  gem 'sassc'

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
    gem 'shrine'
    gem 'shrine-mongoid'
    gem 'image_processing'
  end
end
