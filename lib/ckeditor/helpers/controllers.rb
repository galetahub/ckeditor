module Ckeditor
  module Helpers
    module Controllers
      extend ActiveSupport::Concern

      protected

      def ckeditor_current_user
        instance_exec(&Ckeditor.current_user_method)
      end

      def ckeditor_authorize!
        instance_exec(&Ckeditor.authorize_with)
      end

      def ckeditor_pictures_scope(options = {})
        ckeditor_filebrowser_scope(options)
      end

      def ckeditor_attachment_files_scope(options = {})
        ckeditor_filebrowser_scope(options)
      end

      def ckeditor_filebrowser_scope(options = {})
        { order: [:id, :desc] }.merge!(options)
      end
    end
  end
end
