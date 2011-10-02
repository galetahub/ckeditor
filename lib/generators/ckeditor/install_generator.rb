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
        
        in_root do
          filepath = "tmp/#{filename}"
          get(download_url, filepath)

          if File.exist?(filepath)
            FileUtils.mkdir_p(install_dir)
            Ckeditor::Utils.extract(filepath, install_dir)
            FileUtils.rm_rf(filepath)
          end
        end
      end
      
      def update_javascripts      
        in_root do
          directory "ckeditor/filebrowser", "#{install_dir}/ckeditor/filebrowser"
          directory "ckeditor/plugins", "#{install_dir}/ckeditor/plugins"
          copy_file "ckeditor/config.js", "#{install_dir}/ckeditor/config.js", :force => true
          
          gsub_file "#{install_dir}/ckeditor/plugins/image/dialogs/image.js", 
                    /id\:\'uploadButton\'\,filebrowser\:\'info:txtUrl\'/,
                    "id:'uploadButton',filebrowser:{target:'info:txtUrl',action:'QuickUpload',params:b.config.filebrowserParams()}"
        end	
      end

      def download_javascripts
        js_dir = "#{install_dir}/ckeditor/filebrowser/javascripts"

        say_status("fetching rails.js", "", :green)
        get "https://github.com/rails/jquery-ujs/raw/master/src/rails.js", "#{js_dir}/rails.js"

        say_status("fetching fileuploader.js", "", :green)
        get "https://raw.github.com/galetahub/file-uploader/master/client/fileuploader.js", "#{js_dir}/fileuploader.js"

        say_status("fetching jquery-1.6.2.min.js", "", :green)
        get "https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js", "#{js_dir}/jquery.js"

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
        
        def install_dir
          "app/assets/javascripts"
        end
    end
  end
end
