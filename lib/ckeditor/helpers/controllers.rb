module Ckeditor
  module Helpers
    module Controllers
      extend ActiveSupport::Concern
      
      protected
        
        def ckeditor_current_user
          instance_eval &Ckeditor.current_user_method
        end

        def ckeditor_authorize!
          instance_eval &Ckeditor.authorize_with
        end
        
        def ckeditor_before_create_asset(asset)
          begin
            asset.assetable = ckeditor_current_user  if respond_to?(:current_user)
          rescue NameError => e
            # With mongoid you will get an error here if the model does not specify the reverse association
            # The error will be something like like 'NameError: Uninitialized constant Assetable'
            Rails.logger.fatal "You need to specify the reverse association for Assetable."
            Rails.logger.fatal "If you have a user model, you have to specify something like has_many :assets, as: :assetable, class_name: 'Ckeditor::Asset'"
          end
          
          return true
        end
        
        def ckeditor_pictures_scope(options = {})
          ckeditor_filebrowser_scope(options)
        end
        
        def ckeditor_attachment_files_scope(options = {})
          ckeditor_filebrowser_scope(options)
        end
        
        def ckeditor_filebrowser_scope(options = {})
          { :order => [:id, :desc] }.merge(options)
        end
    end
  end
end
