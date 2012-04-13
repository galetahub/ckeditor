# encoding: utf-8
module Ckeditor
  module Utils
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
        js_options = applay_options(options)
        js = ["if (CKEDITOR.instances['#{dom_id}']) {CKEDITOR.remove(CKEDITOR.instances['#{dom_id}']);}"]
        
        if js_options.blank?
          js << "CKEDITOR.replace('#{dom_id}');"
        else
          js << "CKEDITOR.replace('#{dom_id}', { #{js_options} });"
        end

        "$(document).ready(function(){ #{js.join} });".html_safe
      end
      
      def js_fileuploader(uploader_type, options = {})
        options = { :multiple => true, :element => "fileupload" }.merge(options)
        
        case uploader_type.to_s.downcase
          when "image" then
            options[:action] = "^EDITOR.config.filebrowserImageUploadUrl"
            options[:allowedExtensions] = Ckeditor.image_file_types
          when "flash" then
            options[:action] = "^EDITOR.config.filebrowserFlashUploadUrl"
            options[:allowedExtensions] = ["swf"]
          else
            options[:action] = "^EDITOR.config.filebrowserUploadUrl"
            options[:allowedExtensions] = Ckeditor.attachment_file_types
        end
        
        js_options = applay_options(options)
        
        "$(document).ready(function(){ new qq.FileUploaderInput({ #{js_options} }); });".html_safe
      end
      
      def applay_options(options)
        str = []
        
        options.each do |key, value|
          item = case value
            when String then
              value.split(//).first == '^' ? value.slice(1..-1) : "'#{value}'"
            when Hash then 
              "{ #{applay_options(value)} }"
            when Array then 
              arr = value.collect { |v| "'#{v}'" }
              "[ #{arr.join(',')} ]"
            else value
          end
          
          str << %Q{"#{key}": #{item}}
        end
        
        str.sort.join(',')
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
