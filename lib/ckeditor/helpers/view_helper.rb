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
        output_buffer << javascript_tag(Utils.js_replace(element_id, options))
        
        output_buffer
      end
    end
  end
end
