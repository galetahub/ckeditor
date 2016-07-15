require 'rails/generators'
require 'rails/generators/migration'

module Ckeditor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc 'Generates migration for Asset (Picture, AttachmentFile) models'

      # ORM configuration
      class_option :orm, type: :string, default: 'active_record',
                         desc: 'Backend processor for upload support'

      class_option :backend, type: :string, default: 'paperclip',
                             desc: 'paperclip (default), carrierwave, refile or dragonfly'

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      def self.next_migration_number(_dirname)
        Time.now.strftime('%Y%m%d%H%M%S')
      end

      # copy configuration
      def copy_initializer
        template 'ckeditor.rb', 'config/initializers/ckeditor.rb'

        if backend_dragonfly?
          template 'base/dragonfly/initializer.rb', 'config/initializers/ckeditor_dragonfly.rb'
        end
      end

      def mount_engine
        route "mount Ckeditor::Engine => '/ckeditor'"
      end

      def create_models
        [:asset, :picture, :attachment_file].each do |filename|
          template "#{generator_dir}/ckeditor/#{filename}.rb",
                   File.join('app/models', ckeditor_dir, "#{filename}.rb")
        end

        if backend_carrierwave?
          template "#{uploaders_dir}/uploaders/ckeditor_attachment_file_uploader.rb",
                   File.join('app/uploaders', 'ckeditor_attachment_file_uploader.rb')

          template "#{uploaders_dir}/uploaders/ckeditor_picture_uploader.rb",
                   File.join('app/uploaders', 'ckeditor_picture_uploader.rb')
        end
      end

      def create_ckeditor_migration
        if ['active_record'].include?(orm)
          migration_template "#{generator_dir}/migration.rb",
                             File.join('db/migrate', 'create_ckeditor_assets.rb')
        end
      end

      protected

      def backend_carrierwave?
        backend == 'carrierwave'
      end

      def backend_dragonfly?
        backend == 'dragonfly'
      end

      def ckeditor_dir
        'ckeditor'
      end

      def generator_dir
        @generator_dir ||= [orm, backend].join('/')
      end

      def uploaders_dir
        @uploaders_dir ||= 'base/carrierwave'
      end

      def orm
        (options[:orm] || 'active_record').to_s
      end

      def backend
        (options[:backend] || 'paperclip').to_s
      end
    end
  end
end
