# encoding: utf-8
require 'active_support/json/encoding'

module Ckeditor
  module Utils
    autoload :JavascriptCode, 'ckeditor/utils/javascript_code'
    autoload :ContentTypeDetector, 'ckeditor/utils/content_type_detector'

    class << self
      def escape_single_quotes(str)
        str.gsub('\\','\0\0').gsub('</','<\/').gsub(/\r\n|\n|\r/, "\\n").gsub(/["']/) { |m| "\\#{m}" }
      end

      def parameterize_filename(filename)
        return filename unless Ckeditor.parameterize_filenames

        extension = File.extname(filename)
        basename = filename.gsub(/#{extension}$/, '')

        # R Peck 04/04/2017
        # Old Rails (4.x.x -> https://apidock.com/rails/v4.2.7/String/parameterize)
        # New Rails (5.x.x -> https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/string/inflections.rb#L186)
        # New Rails requires hash
        [basename.parameterize((Rails::VERSION::MAJOR > 5 ? '_' : {separator: '_'})), extension].join.downcase
      end

      def js_replace(dom_id, options = nil)
        replace = if options && !options.keys.empty?
                    js_options = ActiveSupport::JSON.encode(options)
                    "CKEDITOR.replace('#{dom_id}', #{js_options});"
                  else
                    "CKEDITOR.replace('#{dom_id}');"
                  end

        js_init_ckeditor(dom_id, replace)
      end

      def js_init_ckeditor(dom_id, replace)
        %((function() {
            if (typeof CKEDITOR != 'undefined') {
              if (CKEDITOR.instances['#{dom_id}']) { CKEDITOR.instances['#{dom_id}'].destroy(); }
              #{replace}
            }
          })();)
      end

      def js_fileuploader(uploader_type, options = {})
        options = { multiple: true, element: 'fileupload' }.merge(options)

        case uploader_type.to_s.downcase
        when 'image' then
          options[:action] = JavascriptCode.new('EDITOR.config.filebrowserImageUploadUrl')
          options[:allowedExtensions] = Ckeditor.image_file_types
        when 'flash' then
          options[:action] = JavascriptCode.new('EDITOR.config.filebrowserFlashUploadUrl')
          options[:allowedExtensions] = Ckeditor.flash_file_types
        else
          options[:action] = JavascriptCode.new('EDITOR.config.filebrowserUploadUrl')
          options[:allowedExtensions] = Ckeditor.attachment_file_types
        end

        js_options = ActiveSupport::JSON.encode(options)
        js_options.gsub!(/"(EDITOR\.config\.filebrowser(Image|Flash|)UploadUrl)"/, '\1')

        "(function() { new qq.FileUploaderInput(#{js_options}); }).call(this);".html_safe
      end

      def filethumb(filename)
        extname = filename.blank? ? 'unknown' : File.extname(filename).gsub(/^\./, '')
        image = "#{extname}.gif"
        source = Ckeditor.root_path.join('app/assets/images/ckeditor/filebrowser/thumbs')

        image = 'unknown.gif' unless File.exist?(File.join(source, image))

        File.join(Ckeditor.relative_path, 'filebrowser/thumbs', image)
      end

      def select_assets(path, relative_path)
        relative_folder = Ckeditor.root_path.join(relative_path)
        folder = relative_folder.join(path)
        extensions = '*.{js,css,png,gif,jpg,html}'
        languages = (Ckeditor.assets_languages || [])

        # Files at root
        files = Dir[folder.join(extensions)]

        # Filter plugins
        if Ckeditor.assets_plugins.nil?
          files += Dir[folder.join('plugins', '**', extensions)]
        else
          Ckeditor.assets_plugins.each do |plugin|
            files += Dir[folder.join('plugins', plugin, '**', extensions)]
          end
        end

        # Other folders
        Dir[folder.join('*/')].each do |subfolder|
          path = Pathname.new(subfolder)
          next if ['plugins'].include?(path.basename.to_s)
          files += Dir[path.join('**', extensions)]
        end

        files.inject([]) do |items, name|
          file = Pathname.new(name)
          base = file.basename('.*').to_s

          if !name.include?('/lang/') || languages.include?(base)
            items << file.relative_path_from(relative_folder).to_s
          end

          items
        end
      end
    end
  end
end
