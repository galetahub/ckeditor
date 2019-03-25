# frozen_string_literal: true

class Ckeditor::Picture < Ckeditor::Asset
  validates_property :format, of: :data, in: image_file_types unless image_file_types.empty?
  validates_property :image?, of: :data, as: true, message: :invalid

  def url_content
    data.thumb('800x800>').url
  end

  def url_thumb
    data.thumb('118x100#').url(url_thumb_options)
  end
end
