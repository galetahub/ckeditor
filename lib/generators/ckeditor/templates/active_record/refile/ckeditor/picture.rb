class Ckeditor::Picture < Ckeditor::Asset
  attachment :data, extension: image_file_types

  def url_content
    url
  end

  def url_thumb
    url(:fill, 118, 100)
  end
end
