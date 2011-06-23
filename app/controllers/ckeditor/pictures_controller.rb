class Ckeditor::PicturesController < Ckeditor::BaseController

  def index
    @pictures = Ckeditor.image_model.order("id DESC")
    respond_with(@pictures) 
  end
  
  def create
    @picture = Ckeditor.image_model.new
	  respond_with_asset(@picture)
  end
  
  def destroy
    @picture.destroy
    respond_with(@picture, :location => ckeditor_pictures_path)
  end
  
  protected
  
    def find_asset
      @picture = Ckeditor.image_model.find(params[:id])
    end
end
