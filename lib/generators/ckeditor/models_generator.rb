require 'rails/generators'
require 'rails/generators/migration'

module Ckeditor
  module Generators
    class ModelsGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc "Generates migration for Asset (Picture, AttachmentFile) models"

      # ORM configuration
      class_option :orm, :type => :string, :default => "active_record",
        :desc => "Backend processor for upload support"

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates', 'models/'))
      end

      def self.next_migration_number(dirname)
        Time.now.strftime("%Y%m%d%H%M%S")
      end

      def create_models
        template "#{generator_dir}/ckeditor/asset.rb",
                 File.join('app/models', ckeditor_dir, "asset.rb")

        template "#{generator_dir}/ckeditor/picture.rb",
                 File.join('app/models', ckeditor_dir, "picture.rb")

        template "#{generator_dir}/ckeditor/attachment_file.rb",
                 File.join('app/models', ckeditor_dir, "attachment_file.rb")
      end

      def create_migration
        if options[:orm] == "active_record"
          migration_template "#{generator_dir}/migration.rb", File.join('db/migrate', "create_ckeditor_assets.rb")
        end
      end

      protected

        def ckeditor_dir
          'ckeditor'
        end

        def generator_dir
          options[:orm] || "active_record"
        end
    end
  end
end
