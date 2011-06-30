class Ckeditor::PicturesController < Ckeditor::BaseController

  def index
    @pictures = Ckeditor.picture_model.find_all(:order => [:id, :desc])
    respond_with(@pictures) 
  end
  
  def create
    @picture = Ckeditor::Picture.new
	  respond_with_asset(@picture)
  end
  
  def destroy
    @picture.destroy
    respond_with(@picture, :location => ckeditor_pictures_path)
  end
  
  protected
  
    def find_asset
      @picture = Ckeditor.picture_model.get!(params[:id])
    end
end
