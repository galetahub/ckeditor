source "http://rubygems.org"

gemspec

gem "rails", "3.2.3"

platforms :mri_18 do
  group :test do
    gem 'ruby-debug'
    gem 'SystemTimer'
  end
end

platforms :ruby do
  gem "sqlite3"

  group :development do
    gem "unicorn", "~> 4.0.1"
  end

  group :development, :test do
    gem "capybara", ">= 0.4.0"
    gem "mynyml-redgreen", "~> 0.7.1", :require => 'redgreen'
  end

  group :active_record do
    gem "paperclip", "~> 3.0.3"
    gem "carrierwave"
    gem "dragonfly"
    gem "mini_magick"
  end

  group :mongoid do
    gem "mongoid"
    gem "bson_ext"
    gem 'mongoid-paperclip', :require => 'mongoid_paperclip'
    gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
  end
end
