class Ckeditor::BaseController < ApplicationController
  respond_to :html, :json
  layout "ckeditor"
  
  before_filter :set_locale

  protected
    
    def set_locale
      if !params[:langCode].blank? && I18n.available_locales.include?(params[:langCode].to_sym)
        I18n.locale = params[:langCode]
      end
    end
    
    def respond_with_asset(asset)
      params[:qqfile] = params.delete(:upload) unless params[:CKEditor].blank?
	    asset.data = Ckeditor::Http.normalize_param(params[:qqfile], request)
	    
      if asset.save
        body = params[:CKEditor].blank? ? record.to_json(:only=>[:id, :type]) : %Q"<script type='text/javascript'>
          window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{Ckeditor::Utils.escape_single_quotes(record.url_content)}');
        </script>"
        
        render :text => body
      else
        render :nothing => true
      end
    end
end
