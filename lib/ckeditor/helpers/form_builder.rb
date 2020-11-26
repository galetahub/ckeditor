# frozen_string_literal: true

module Ckeditor
  module Helpers
    module FormBuilder
      def cktext_area(method, options = {})
        @template.cktext_area(@object_name, method, objectify_options(options))
      end
    end
  end
end
