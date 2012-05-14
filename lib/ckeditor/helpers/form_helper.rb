module Ckeditor
  module Helpers
    module FormHelper
      extend ActiveSupport::Concern
      
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::JavaScriptHelper
      
      def cktext_area(object_name, method, options = {})
        options = { :language => I18n.locale.to_s }.merge(options)
        input_html = (options.delete(:input_html) || {}).stringify_keys
        js_content_for_section = options.delete(:js_content_for)
        
        instance_tag = ActionView::Base::InstanceTag.new(object_name, method, self, options.delete(:object))
        instance_tag.send(:add_default_name_and_id, input_html)
        
        output_buffer = ActiveSupport::SafeBuffer.new
        output_buffer << instance_tag.to_text_area_tag(input_html)
        
        js = Utils.js_replace(input_html['id'], options)
        
        output_buffer << (js_content_for_section ? content_for(js_content_for_section, js) : javascript_tag(js))
        output_buffer
      end
    end
  end
end
