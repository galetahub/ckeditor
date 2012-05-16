require 'rails'
require 'ckeditor'

module Ckeditor
  class Engine < ::Rails::Engine
    isolate_namespace Ckeditor
    
    config.action_view.javascript_expansions[:ckeditor] = "ckeditor/ckeditor"
    
    initializer "ckeditor.assets_precompile", :group => :assets do |app|
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
      # Don't load the hook for Formtastic < 2.0.0 that (it crashes), apparently, didn't define a Formtastic::Inputs.
      if Object.const_defined?("Formtastic") && Formtastic.const_defined?("Inputs")
        require "ckeditor/hooks/formtastic"
      end
      
      if Object.const_defined?("SimpleForm")
        require "ckeditor/hooks/simple_form"
      end
    end
  end
end
