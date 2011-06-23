module Ckeditor
  module Hooks
    module FormtasticBuilder
      def self.included(base)
        base.send(:include, InstanceMethods)
      end
    
      module InstanceMethods
        def ckeditor_input(method, options)
          basic_input_helper(:cktext_area, :text, method, options)
        end
      end
    end
  end
end
