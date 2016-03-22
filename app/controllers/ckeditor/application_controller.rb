class Ckeditor::ApplicationController < Ckeditor.parent_controller.constantize
  layout 'ckeditor/application'

  before_action :find_asset, :only => [:destroy]
  before_action :ckeditor_authorize!
  before_action :authorize_resource

  protected

    def respond_with_asset(asset)
      _response = Ckeditor::AssetResponse.new(asset, request)
      _callback = ckeditor_before_create_asset(asset)

      if _callback && asset.save
        render _response.success(config.relative_url_root)
      else
        render _response.errors
      end
    end
end
