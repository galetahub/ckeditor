class Ckeditor::ApplicationController < ActionController::Base
  respond_to :html, :json
  layout 'ckeditor/application'

  before_filter :find_asset, :only => [:destroy]
  before_filter :ckeditor_authorize!
  before_filter :authorize_resource

  protected

    def respond_with_asset(asset)
      file = params[:CKEditor].blank? ? params[:qqfile] : params[:upload]
      asset.data = Ckeditor::Http.normalize_param(file, request)

      callback = ckeditor_before_create_asset(asset)

      if callback && asset.save
        body = params[:CKEditor].blank? ? asset.to_json(:only=>[:id, :type]) : %Q"<script type='text/javascript'>
          window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{config.relative_url_root}#{Ckeditor::Utils.escape_single_quotes(asset.url_content)}');
        </script>"

        render :text => body
      else
        if params[:CKEditor]
          body = %Q"<script type='text/javascript'>
                      window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, null, '#{asset.errors.full_messages_for(:data).join('\n')}');
                    </script>"
          asset.errors.get(:data).any? && Ckeditor.alert_errors ? render(:text => body, :status => :unprocessable_entity) : render(:nothing => true)
        else
          render(:nothing => true)
        end
      end
    end
end
