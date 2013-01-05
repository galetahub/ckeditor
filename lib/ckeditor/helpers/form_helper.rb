module Ckeditor
  module Helpers
    module FormHelper
      extend ActiveSupport::Concern
      
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::JavaScriptHelper
      
      def cktext_area(object_name, method, options = {})
        options = (options || {}).stringify_keys
        ck_options = (options.delete('ckeditor') || {}).stringify_keys
        
        instance_tag = ActionView::Base::InstanceTag.new(object_name, method, self, options.delete('object'))
        instance_tag.send(:add_default_name_and_id, options) if options['id'].blank?
        
        output_buffer = ActiveSupport::SafeBuffer.new
        output_buffer << instance_tag.to_text_area_tag(options)
        output_buffer << javascript_tag(Utils.js_replace(options['id'], ck_options))
        output_buffer
      end
    end
  end
end
