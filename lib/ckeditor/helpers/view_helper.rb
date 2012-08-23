module Ckeditor
  module Helpers
    module ViewHelper
      extend ActiveSupport::Concern
      
      def cktext_area_tag(name, content = nil, options = {})
        element_id = sanitize_to_id(options[:id] || name)
        options = { :language => I18n.locale.to_s }.merge(options)
        input_html = { :id => element_id }.merge( options.delete(:input_html) || {} )
        js_content_for_section = options.delete(:js_content_for)
        
        output_buffer = ActiveSupport::SafeBuffer.new
        output_buffer << text_area_tag(name, content, input_html)
        
        js = Utils.js_replace(element_id, options)
        
        output_buffer << (js_content_for_section ? content_for(js_content_for_section, js) : javascript_tag(js))
        output_buffer
      end
    end
  end
end
