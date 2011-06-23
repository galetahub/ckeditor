source "http://rubygems.org"

gemspec

gem "rails", "3.0.9"

platforms :ruby do
  gem "mysql2", '0.2.11'
    
  group :development, :test do
    gem "capybara", ">= 0.4.0"
    gem "redgreen", "~> 1.2.2"
    
    # To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
    # gem 'ruby-debug'
    # gem 'ruby-debug19'
  end
  
  group :development do
    gem "mongrel"
  end
end
