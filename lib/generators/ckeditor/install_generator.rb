require 'rails/generators'
require 'fileutils'

module Ckeditor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :version, :type => :string, :default => Ckeditor::Version::EDITOR,
                   :desc => "Version of ckeditor which be install"

      class_option :orm, :type => :string, :default => 'active_record',
                   :desc => "Backend processor for upload support"

      desc "Download and install ckeditor"

      def self.source_root
        @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
      end

      # copy configuration
      def copy_initializer
        template "ckeditor.rb", "config/initializers/ckeditor.rb"
      end

      # copy ckeditor files
      def install_ckeditor
        say_status("fetching #{filename}", "", :green)
        get(download_url, "tmp/#{filename}")

        filepath = Rails.root.join("tmp/#{filename}")

        if File.exist?(filepath)
          Ckeditor::Utils.extract(filepath, Rails.root.join('public', 'javascripts'))
          directory "ckeditor", "public/javascripts/ckeditor"
          FileUtils.rm_rf(filepath)
        end
      end

      def download_javascripts
        js_dir = "public/javascripts/ckeditor/filebrowser/javascripts"

        say_status("fetching rails.js", "", :green)
        get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "#{js_dir}/rails.js"

        say_status("fetching fileuploader.js", "", :green)
        get "https://raw.github.com/galetahub/file-uploader/master/client/fileuploader.js", "#{js_dir}/fileuploader.js"

        say_status("fetching jquery-1.6.1.min.js", "", :green)
        get "http://code.jquery.com/jquery-1.6.1.min.js", "#{js_dir}/jquery.js"

        say_status("fetching jquery.tmpl.min.js", "", :green)
        get "https://raw.github.com/jquery/jquery-tmpl/master/jquery.tmpl.min.js", "#{js_dir}/jquery.tmpl.js"
      end

      protected

        def download_url
          "http://download.cksource.com/CKEditor/CKEditor/CKEditor%20#{options[:version]}/#{filename}"
        end

        def filename
          "ckeditor_#{options[:version]}.tar.gz"
        end
    end
  end
end
