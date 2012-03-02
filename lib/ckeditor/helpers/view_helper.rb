module Ckeditor
  module Helpers
    module ViewHelper
      extend ActiveSupport::Concern
      
      def cktext_area_tag(name, content = nil, options = {})
        element_id = sanitize_to_id(name)
        options = { :language => I18n.locale.to_s }.merge(options)
        input_html = { :id => element_id }.merge( options.delete(:input_html) || {} )
        
        output_buffer = ActiveSupport::SafeBuffer.new
        output_buffer << text_area_tag(name, content, input_html)
        
        js_content_for_section = options.delete(:js_content_for)
        js = Utils.js_replace(element_id, options)
        if js_content_for_section
          content_for(js_content_for_section) { js.html_safe }
        else
          output_buffer << javascript_tag(js)
        end
        
        output_buffer
      end
    end
  end
end
