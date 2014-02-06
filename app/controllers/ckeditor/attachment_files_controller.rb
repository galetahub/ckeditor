class Ckeditor::AttachmentFilesController < Ckeditor::ApplicationController

  def index
    @attachments = Ckeditor.attachment_file_adapter.find_all(ckeditor_attachment_files_scope)
    @attachments = Ckeditor::Paginatable.new(@attachments).page(params[:page])

    respond_with(@attachments, :layout => @attachments.first_page?)
  end

  def create
    @attachment = Ckeditor.attachment_file_model.new
    respond_with_asset(@attachment)
  end

  def destroy
    @attachment.destroy
    respond_with(@attachment, :location => attachment_files_path)
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
