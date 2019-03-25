# frozen_string_literal: true

class Ckeditor::AttachmentFilesController < Ckeditor::ApplicationController
  skip_before_action :verify_authenticity_token, only: :create, raise: false

  def index
    @attachments = Ckeditor.attachment_file_adapter.find_all(ckeditor_attachment_files_scope)
    @attachments = Ckeditor::Paginatable.new(@attachments).page(params[:page])

    respond_to do |format|
      format.html { render layout: @attachments.first_page? }
    end
  end

  def create
    @attachment = Ckeditor.attachment_file_model.new
    respond_with_asset(@attachment)
  end

  def destroy
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to attachment_files_path }
      format.json { render json: @attachment, status: 204 }
    end
  end

  protected

  def find_asset
    @attachment = Ckeditor.attachment_file_adapter.get!(params[:id])
  end

  def authorize_resource
    model = (@attachment || Ckeditor.attachment_file_model)
    @authorization_adapter.try(:authorize, params[:action], model)
  end
end
