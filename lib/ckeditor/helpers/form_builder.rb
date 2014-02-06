module Ckeditor
  module Helpers
    module FormBuilder
      extend ActiveSupport::Concern

      def cktext_area(method, options = {})
        @template.send("cktext_area", @object_name, method, objectify_options(options))
      end
    end
  end
end
