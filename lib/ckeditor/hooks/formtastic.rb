module Ckeditor
  module Hooks
    module FormtasticBuilder
      include Formtastic::Inputs::Base
      def to_html
        input_wrapping do
          label_html <<
          builder.cktext_area(method, input_html_options)
        end
      end
    end
  end
end
