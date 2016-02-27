require 'rails/generators'

module Ckeditor
  module Generators
    class PunditPolicyGenerator < Rails::Generators::Base

      desc "Generates policy files for Pundit"

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      # copy configuration
      def copy_policy_files
        [:picture, :attachment_file, :paginatable].each do |model_name|
          template "pundit_policy/#{model_name}_policy.rb", "app/policies/ckeditor/#{model_name}_policy.rb"
        end
      end

    end
  end
end
