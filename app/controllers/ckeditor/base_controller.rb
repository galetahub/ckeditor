class Ckeditor::BaseController < ApplicationController
  respond_to :html, :json
  layout "ckeditor"
  
  before_filter :set_locale
  before_filter :find_asset, :only => [:destroy]
  before_filter :ckeditor_authenticate

  protected
    
    def set_locale
      if !params[:langCode].blank? && I18n.available_locales.include?(params[:langCode].to_sym)
        I18n.locale = params[:langCode]
      end
    end
    
    def respond_with_asset(asset)
      file = params[:CKEditor].blank? ? params[:qqfile] : params[:upload]
	    asset.data = Ckeditor::Http.normalize_param(file, request)
	    
	    callback = ckeditor_before_create_asset(asset)
	    
      if callback && asset.save
      	result = asset.serializable_hash(:only => [:id, :type], :methods => [:url_content, :size, :url_thumb, :filename, :format_created_at])
        body = params[:CKEditor].blank? ? result.to_json : %Q"<script type='text/javascript'>
          window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{Ckeditor::Utils.escape_single_quotes(asset.url_content)}');
        </script>"
        
        render :text => body
      else
        render :nothing => true
      end
    end
end