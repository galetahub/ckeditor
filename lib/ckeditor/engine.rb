require 'rails'
require 'ckeditor'

module Ckeditor
  class Engine < ::Rails::Engine
    isolate_namespace Ckeditor
    
    config.action_view.javascript_expansions[:ckeditor] = "ckeditor/ckeditor"
    
    initializer "ckeditor.assets_precompile" do |app|
      app.config.assets.precompile += Ckeditor.assets
    end
    
    initializer "ckeditor.helpers" do
      ActiveSupport.on_load(:action_controller) do
        ActionController::Base.send :include, Ckeditor::Helpers::Controllers
      end
    
      ActiveSupport.on_load :action_view do
        ActionView::Base.send :include, Ckeditor::Helpers::ViewHelper
        ActionView::Base.send :include, Ckeditor::Helpers::FormHelper
        ActionView::Helpers::FormBuilder.send :include, Ckeditor::Helpers::FormBuilder
      end
    end
    
    initializer "ckeditor.hooks" do
      if Object.const_defined?("Formtastic")
        require "ckeditor/hooks/formtastic"
      end
      
      if Object.const_defined?("SimpleForm")
        ::SimpleForm::FormBuilder.send :include, Ckeditor::Hooks::SimpleFormBuilder
      end
    end
  end
end
