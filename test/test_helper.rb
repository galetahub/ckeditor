# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
CKEDITOR_ORM = (ENV["CKEDITOR_ORM"] || :active_record).to_sym
CKEDITOR_BACKEND = (ENV["CKEDITOR_BACKEND"] || :paperclip).to_sym

$:.unshift File.dirname(__FILE__)
puts "\n==> Ckeditor.orm = #{CKEDITOR_ORM.inspect}. CKEDITOR_ORM = (active_record|mongoid)"
puts "\n==> Ckeditor.backend = #{CKEDITOR_BACKEND.inspect}. CKEDITOR_BACKEND = (paperclip|carrierwave|refile|dragonfly)"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'redgreen'

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require "capybara/rails"
Capybara.default_driver   = :rack_test
Capybara.default_selector = :css

# Run specific orm operations
require "orm/#{CKEDITOR_ORM}"

# Load support files
$:.unshift File.expand_path('../support', __FILE__)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# For generators
require "rails/generators/test_case"
require "generators/ckeditor/install_generator"

# Run template migration for the selected backend
if CKEDITOR_ORM == :active_record
  require "generators/ckeditor/templates/active_record/#{CKEDITOR_BACKEND}/migration.rb"
  CreateCkeditorAssets.new.up
end
