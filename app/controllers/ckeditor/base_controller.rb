class Ckeditor::BaseController < ApplicationController
  respond_to :html, :json
  layout "ckeditor"

  protected
    
    def respond_with_asset(record)
      unless params[:CKEditor].blank?	  
	      params[@swf_file_post_name] = params.delete(:upload)
	    end
	    
	    options = {}
	    
	    params.each do |k, v|
	      key = k.to_s.downcase
	      options[key] = v if record.respond_to?("#{key}=")
	    end
      
      record.attributes = options
      record.user ||= current_user if respond_to?(:current_user)
      
      if record.valid? && record.save
        body = params[:CKEditor].blank? ? record.to_json(:only=>[:id, :type], :methods=>[:url, :content_type, :size, :filename, :format_created_at], :root => "asset") : %Q"<script type='text/javascript'>
          window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{Ckeditor::Utils.escape_single_quotes(record.url_content)}');
        </script>"
        
        render :text => body
      else
        render :nothing => true
      end
    end
end
