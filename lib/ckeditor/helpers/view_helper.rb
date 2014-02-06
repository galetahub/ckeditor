module Ckeditor
  module Helpers
    module ViewHelper
      extend ActiveSupport::Concern

      def cktext_area_tag(name, content = nil, options = {})
        TextArea.new(self, options).render_tag(name, content)
      end
    end
  end
end
