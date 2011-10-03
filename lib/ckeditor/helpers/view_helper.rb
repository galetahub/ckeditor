module Ckeditor
  module Helpers
    module ViewHelper
      extend ActiveSupport::Concern

      def cktext_area_tag(name, content = nil, options = {})
        input_html = options.delete(:input_html) || {}
        element_id = input_html.delete(:id) || sanitize_to_id(name)
        input_html[:id]= element_id

        options = { :language => I18n.locale.to_s }.merge(options)

        output_buffer = ActiveSupport::SafeBuffer.new
        output_buffer << text_area_tag(name, content, input_html)
        output_buffer << javascript_tag(Utils.js_replace(element_id, options))

        output_buffer
      end
    end
  end
end
