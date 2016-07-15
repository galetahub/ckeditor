require 'simple_form'

module Ckeditor
  module Hooks
    module SimpleForm
      class CkeditorInput < ::SimpleForm::Inputs::Base
        def input(_wrapper_options = nil)
          @builder.cktext_area(attribute_name, input_html_options)
        end
      end
    end
  end
end

::SimpleForm::FormBuilder.map_type :ckeditor, to: Ckeditor::Hooks::SimpleForm::CkeditorInput
