# encoding: utf-8
require 'active_support/json/encoding'

module Ckeditor
  module Utils
    class JavascriptCode < String
      def to_json(options = nil)
        self
      end

      def as_json(options = nil)
        ActiveSupport::JSON::Variable.new(to_s).freeze
      end
    end

    class << self
      def escape_single_quotes(str)
        str.gsub('\\','\0\0').gsub('</','<\/').gsub(/\r\n|\n|\r/, "\\n").gsub(/["']/) { |m| "\\#{m}" }
      end

      def parameterize_filename(filename)
        return filename unless Ckeditor.parameterize_filenames

        extension = File.extname(filename)
        basename = filename.gsub(/#{extension}$/, "")

        [basename.parameterize('_'), extension].join.downcase
      end

      def js_replace(dom_id, options = {})
        js_options = ActiveSupport::JSON.encode(options)

        js = ["if (CKEDITOR.instances['#{dom_id}']) {CKEDITOR.remove(CKEDITOR.instances['#{dom_id}']);}"]
        js << "CKEDITOR.replace('#{dom_id}', #{js_options});"

        "(window.onload = function() { var verify_ckeditor = function(){ if(typeof CKEDITOR === 'undefined') { setTimeout(verify_ckeditor, 300); } else { if(CKEDITOR.instances['#{dom_id}']){return;} #{js.join} } }; setTimeout(verify_ckeditor, 300); }).call(this);".html_safe
      end

      def js_fileuploader(uploader_type, options = {})
        options = { :multiple => true, :element => "fileupload" }.merge(options)

        case uploader_type.to_s.downcase
          when "image" then
            options[:action] = JavascriptCode.new("EDITOR.config.filebrowserImageUploadUrl")
            options[:allowedExtensions] = Ckeditor.image_file_types
          when "flash" then
            options[:action] = JavascriptCode.new("EDITOR.config.filebrowserFlashUploadUrl")
            options[:allowedExtensions] = ["swf"]
          else
            options[:action] = JavascriptCode.new("EDITOR.config.filebrowserUploadUrl")
            options[:allowedExtensions] = Ckeditor.attachment_file_types
        end

        js_options = ActiveSupport::JSON.encode(options)

        "(function() { new qq.FileUploaderInput(#{js_options}); }).call(this);".html_safe
      end

      def filethumb(filename)
        extname = filename.blank? ? "unknown" : File.extname(filename).gsub(/^\./, '')
	      image = "#{extname}.gif"
	      source = Ckeditor.root_path.join("app/assets/javascripts/ckeditor/filebrowser/images/thumbs")

	      unless File.exists?(File.join(source, image))
	        image = "unknown.gif"
	      end

	      File.join(Ckeditor.relative_path, "filebrowser/images/thumbs", image)
      end

      def select_assets(path, relative_path)
        folder = File.join(path, '**')
        relative_folder = Ckeditor.root_path.join(relative_path)

        Dir[Ckeditor.root_path.join(folder, '*.{js,css}')].inject([]) do |list, file|
          list << Pathname.new(file).relative_path_from(relative_folder).to_s
          list
        end
      end
    end
  end
end
