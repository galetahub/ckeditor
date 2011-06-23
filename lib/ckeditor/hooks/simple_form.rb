module Ckeditor
  module Hooks
    module SimpleFormBuilder
      class CkeditorInput < ::SimpleForm::Inputs::Base
        def input
          @builder.send(:cktext_area, attribute_name, input_html_options)
        end
      end
      
      def self.included(base)
        base.send(:include, InstanceMethods)
      end
    
      module InstanceMethods
        def ckeditor(attribute_name, options={}, &block)
          column     = find_attribute_column(attribute_name)
          input_type = default_input_type(attribute_name, column, options)

          if block_given?
            SimpleForm::Inputs::BlockInput.new(self, attribute_name, column, input_type, options, &block).render
          else
            CkeditorInput.new(self, attribute_name, column, input_type, options).render
          end
        end
      end
    end
  end
end
