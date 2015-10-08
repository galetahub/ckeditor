source "http://rubygems.org"

gemspec

gem "rails", "4.2.4"

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
    gem 'jquery-rails', '~> 4.0.4'
    gem "capybara", ">= 0.4.0"
    gem "mynyml-redgreen", "~> 0.7.1", :require => 'redgreen'
  end

  group :active_record do
    gem 'paperclip'
    gem "carrierwave"
    gem "dragonfly"
    gem "mini_magick"
    gem "refile", require: "refile/rails"
    gem "refile-mini_magick"
  end

  group :mongoid do
    gem 'mongoid', '~> 5.0.0'
    gem "bson_ext"
    gem 'mongoid-paperclip', :require => 'mongoid_paperclip'
    gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
  end
end
