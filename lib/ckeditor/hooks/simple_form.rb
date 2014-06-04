require 'simple_form'

module Ckeditor::Hooks::SimpleForm
  class CkeditorInput < ::SimpleForm::Inputs::Base
    def input(wrapper_options = nil)
      @builder.cktext_area(attribute_name, input_html_options)
    end
  end
end

::SimpleForm::FormBuilder.map_type :ckeditor, :to => Ckeditor::Hooks::SimpleForm::CkeditorInput

# TODO: remove this after a while, SimpleForm::FormBuilder#ckeditor is deprecated.
class SimpleForm::FormBuilder
  def ckeditor(attribute_name, options={}, &block)
    warn "[DEPRECATION] calling f.ckeditor(:#{attribute_name}, ...) is deprecated, call f.input(:#{attribute_name}, :as => :ckeditor, #{options.to_s[1..-1]}) #{Kernel.caller.first}"
    options[:as] = :ckeditor
    self.input(attribute_name, options, &block)
  end
end
