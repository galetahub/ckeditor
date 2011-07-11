module Ckeditor
  module Helpers
    module Controllers
      extend ActiveSupport::Concern
      
      protected
        
        def ckeditor_authenticate
          return true
        end
        
        def ckeditor_before_create_asset(asset)
          asset.assetable = current_user if respond_to?(:current_user)
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
