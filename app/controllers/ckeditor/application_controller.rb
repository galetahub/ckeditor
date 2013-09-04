class Ckeditor::ApplicationController < ::ApplicationController
  respond_to :html, :json
  
  before_filter :find_asset, :only => [:destroy]
  before_filter :ckeditor_authorize!
  before_filter :authorize_resource

  protected
    
    def respond_with_asset(asset)
      file = params[:CKEditor].blank? ? params[:qqfile] : params[:upload]
      asset.data = Ckeditor::Http.normalize_param(file, request)

      callback = ckeditor_before_create_asset(asset)

      if callback && asset.save
        body = params[:CKEditor].blank? ? asset_to_json(asset) : %Q"<script type='text/javascript'>
          window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{Ckeditor::Utils.escape_single_quotes(asset.url_content)}');
        </script>"
        
        render :text => body
      else
        render :nothing => true
      end
    end

    def asset_to_json(asset)
      JSON.parse(asset.to_json(:only=>[:id, :type])).tap do |hash|
        # Add asset_host to url
        hash["asset"]["url_content"] = view_context.image_path asset.url_content
      end.to_json
    end
end
