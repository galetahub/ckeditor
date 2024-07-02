# frozen_string_literal: true

class Ckeditor::Picture < Ckeditor::Asset
  def url_content
    attachment&.url
  end

  def url_thumb
    attachment&.url
  end
end
