module Ckeditor
  module Helpers
    module FormHelper
      extend ActiveSupport::Concern

      def cktext_area(object_name, method, options = {})
        TextArea.new(self, options).render_instance_tag(object_name, method)
      end
    end
  end
end
