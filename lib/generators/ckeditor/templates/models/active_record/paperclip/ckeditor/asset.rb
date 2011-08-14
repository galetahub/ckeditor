require 'mime/types'

class Ckeditor::Asset < ActiveRecord::Base
  include Ckeditor::Orm::ActiveRecord::AssetBase
  
  before_validation :extract_content_type
  before_create :read_dimensions, :parameterize_filename
  
  delegate :url, :path, :styles, :size, :content_type, :to => :data
  
  def filename
    data_file_name
  end
  
  def has_dimensions?
    respond_to?(:width) && respond_to?(:height)
  end
  
  def image?
    Ckeditor::IMAGE_TYPES.include?(data_content_type)
  end
  
  def geometry
    @geometry ||= Paperclip::Geometry.from_file(data.to_file)
  end
  
  protected
            
    def parameterize_filename
      unless data_file_name.blank?
        filename = Ckeditor::Utils.parameterize_filename(data_file_name)
        self.data.instance_write(:file_name, filename)
      end  
    end
    
    def read_dimensions
      if image? && has_dimensions?
        self.width = geometry.width
        self.height = geometry.height
      end
    end
    
    # Extract content_type from filename using mime/types gem
    def extract_content_type
      if data_content_type == "application/octet-stream" && !data_file_name.blank?
        content_types = MIME::Types.type_for(data_file_name)
        self.data_content_type = content_types.first.to_s unless content_types.empty?
      end
    end
end
