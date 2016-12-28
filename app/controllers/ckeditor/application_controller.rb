class Ckeditor::ApplicationController < Ckeditor.parent_controller.constantize
  layout Ckeditor.controller_layout

  before_action :find_asset, only: [:destroy]
  before_action :ckeditor_authorize!
  before_action :authorize_resource

  layout 'ckeditor/application'

  protected

  def respond_with_asset(asset)
    asset_response = Ckeditor::AssetResponse.new(asset, request)

    if asset.save
      render asset_response.success(config.relative_url_root)
    else
      render asset_response.errors
    end
  end
end
