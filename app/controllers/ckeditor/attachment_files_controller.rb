class Ckeditor::AttachmentFilesController < Ckeditor::BaseController

  def index
    @attachments = Ckeditor.file_model.order("id DESC")
    respond_with(@attachments)
  end
  
  def create
    @attachment = Ckeditor.file_model.new
	  respond_with_asset(@attachment)
  end
  
  def destroy
    @attachment.destroy
    respond_with(@attachment, :location => ckeditor_attachments_path)
  end
  
  protected
  
    def find_asset
      @attachment = Ckeditor.file_model.find(params[:id])
    end
end
