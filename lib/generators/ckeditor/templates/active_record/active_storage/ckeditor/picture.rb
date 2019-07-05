class Ckeditor::Picture < Ckeditor::Asset
  has_one_attached :data
  # for validation, see https://github.com/igorkasyanchuk/active_storage_validations

  def url_content
    rails_representation_url(data.variant(resize: '800>').processed, only_path: true)
  end

  def url_thumb
    rails_representation_url(data.variant(resize: '118x100').processed, only_path: true)
  end
end
