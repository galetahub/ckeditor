# frozen_string_literal: true

require 'rails/generators'

module Ckeditor
  module Generators
    class ActionPolicyGenerator < Rails::Generators::Base
      desc 'Generates policy files for Action Policy'

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      # copy configuration
      def copy_policy_files
        [:picture, :attachment_file].each do |model_name|
          template "action_policy/#{model_name}_policy.rb", "app/policies/ckeditor/#{model_name}_policy.rb"
        end
      end
    end
  end
end
