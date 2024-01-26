# frozen_string_literal: true

class Ckeditor::Picture < Ckeditor::Asset
  include PictureUploader.attachment(:data)

  validates :data, presence: true

  def url_content
    data_url(:content)
  end

  def url_thumb
    data_url(:thumb)
  end

  def path
    data[:thumb].storage.path(data[:thumb].id)
  end
end
