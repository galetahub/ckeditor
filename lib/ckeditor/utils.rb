# frozen_string_literal: true

require 'active_support/json/encoding'

module Ckeditor
  module Utils
    autoload :JavascriptCode, 'ckeditor/utils/javascript_code'

    class << self
      def escape_single_quotes(str)
        str.gsub('\\', '\0\0').gsub('</', '<\/').gsub(/\r\n|\n|\r/, "\\n").gsub(/["']/) { |m| "\\#{m}" }
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
        options = { multiple: true, element: 'fileupload' }.merge!(options)

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

      def assets_pipeline_enabled?
        if Gem::Version.new(::Rails.version.to_s) >= Gem::Version.new('4.0.0')
          defined?(Sprockets::Rails)
        elsif Gem::Version.new(::Rails.version.to_s) >= Gem::Version.new('3.0.0')
          Rails.application.config.assets.enabled
        else
          false
        end
      end
    end
  end
end
