# frozen_string_literal: true

# Configure Rails Envinronment
ENV['RAILS_ENV'] = 'test'
CKEDITOR_ORM = (ENV['CKEDITOR_ORM'] || :active_record).to_sym
CKEDITOR_BACKEND = (ENV['CKEDITOR_BACKEND'] || :carrierwave).to_sym

$LOAD_PATH.unshift File.dirname(__FILE__)
puts "\n==> Ckeditor.orm = #{CKEDITOR_ORM.inspect}. CKEDITOR_ORM = (active_record|mongoid)"
puts "\n==> Ckeditor.backend = #{CKEDITOR_BACKEND.inspect}. CKEDITOR_BACKEND = (shrine|paperclip|active_storage|carrierwave|dragonfly)"

require File.expand_path('dummy/config/environment.rb', __dir__)
require 'rails/test_help'

Rails.backtrace_cleaner.remove_silencers!

# Configure capybara for integration testing
require 'capybara/rails'
Capybara.default_driver   = :rack_test
Capybara.default_selector = :css

# Run specific orm operations
require "orm/#{CKEDITOR_ORM}"

# Load support files
$LOAD_PATH.unshift File.expand_path('support', __dir__)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# For generators
require 'rails/generators/test_case'
require 'generators/ckeditor/install_generator'

# Run template migration for the selected backend
if CKEDITOR_ORM == :active_record
  require "generators/ckeditor/templates/active_record/#{CKEDITOR_BACKEND}/create_ckeditor_assets.rb"
  CreateCkeditorAssets.new.up
end

# For create variants in Active Storage
require 'active_job'
ActiveJob::Base.queue_adapter = :test
