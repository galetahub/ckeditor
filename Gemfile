source "http://rubygems.org"

gemspec

gem "rails", "3.0.9"

platforms :mri_18 do
  group :test do
    gem 'ruby-debug'
  end
end

#platforms :mri_19 do
  #group :test do
    #gem 'ruby-debug19'
  #end
#end

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
    gem "paperclip", "~> 2.3.12"
  end

  group :mongoid do
    gem "mongoid"
    gem "bson_ext"
    gem 'mongoid-paperclip', :require => 'mongoid_paperclip'
  end

end
