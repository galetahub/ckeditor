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
        extension = File.extname(filename)
        basename = filename.gsub(/#{extension}$/, "")
        
        [basename.parameterize('_'), extension].join.downcase
      end
      
      def js_replace(dom_id, options = {})
        js_options = ActiveSupport::JSON.encode(options)
        
        js = ["if (CKEDITOR.instances['#{dom_id}']) {CKEDITOR.remove(CKEDITOR.instances['#{dom_id}']);}"]
        js << "CKEDITOR.replace('#{dom_id}', #{js_options});"

        "$(document).ready(function(){ #{js.join} });".html_safe
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
        
        "$(document).ready(function(){ new qq.FileUploaderInput(#{js_options}); });".html_safe
      end
      
      def filethumb(filename)
        extname = filename.blank? ? "unknown" : File.extname(filename).gsub(/^\./, '')
	      image = "#{extname}.gif"
	      source = Ckeditor.root_path.join("vendor/assets/javascripts/ckeditor/filebrowser/images/thumbs")
	      
	      unless File.exists?(File.join(source, image))
	        image = "unknown.gif"
	      end
	      
	      File.join(Ckeditor.relative_path, "filebrowser/images/thumbs", image)
      end
    end
  end
end
