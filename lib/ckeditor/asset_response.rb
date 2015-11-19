module Ckeditor
  class AssetResponse
    attr_reader :asset, :params

    def initialize(asset, request)
      @asset = asset
      @request = request
      @params = request.params

      @asset.data = Ckeditor::Http.normalize_param(file, @request)
    end

    def json?
      params[:responseType] == 'json'
    end

    def ckeditor?
      !params[:CKEditor].blank?
    end

    def file
      !(ckeditor? || json?) ? params[:qqfile] : params[:upload]
    end

    def success(relative_url_root = nil)
      if json?
        {
          json: { "uploaded" => 1, "fileName" => asset.filename, "url" => asset.url }.to_json
        }
      elsif ckeditor?
        {
          text: %Q"<script type='text/javascript'>
            window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{relative_url_root}#{Ckeditor::Utils.escape_single_quotes(asset.url_content)}');
          </script>"
        }
      else
        {
          json: asset.to_json(only: [:id, :type])
        }
      end
    end

    def errors
      if json?
        {
          json: { "uploaded" => 0, "error" => { "message" => "Upload failed"} }.to_json
        }
      elsif ckeditor?
        {
          text: %Q"<script type='text/javascript'>
            window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, null, '#{Ckeditor::Utils.escape_single_quotes(asset.errors.full_messages.first)}');
          </script>"
        }
      else
        {nothing: true, format: :json}
      end
    end
  end
end