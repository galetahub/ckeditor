# frozen_string_literal: true

module Ckeditor
  class Engine < ::Rails::Engine
    isolate_namespace Ckeditor

    initializer 'ckeditor.assets_precompile', group: :all do |app|
      app.config.assets.precompile += Ckeditor.assets
    end

    initializer 'ckeditor.helpers' do
      ActiveSupport.on_load(:action_controller) do
        ActionController::Base.include Ckeditor::Helpers::Controllers
      end

      ActiveSupport.on_load :action_view do
        ActionView::Base.include Ckeditor::Helpers::ViewHelper
        ActionView::Base.include Ckeditor::Helpers::FormHelper
        ActionView::Helpers::FormBuilder.include Ckeditor::Helpers::FormBuilder
      end
    end

    initializer 'ckeditor.hooks' do
      require 'ckeditor/hooks/formtastic'  if Object.const_defined?('Formtastic')
      require 'ckeditor/hooks/simple_form' if Object.const_defined?('SimpleForm')

      require 'ckeditor/hooks/cancan' if Object.const_defined?('CanCan')
      require 'ckeditor/hooks/pundit' if Object.const_defined?('Pundit')
      require 'ckeditor/hooks/action_policy' if Object.const_defined?('ActionPolicy')
    end

    rake_tasks do
      load Ckeditor.root_path.join('lib/tasks/ckeditor.rake')

      if Rake::Task.task_defined?('assets:precompile')
        Rake::Task['assets:precompile'].enhance do
          Rake::Task['ckeditor:nondigest'].invoke if Ckeditor.run_on_precompile?
        end
      end
    end
  end
end
