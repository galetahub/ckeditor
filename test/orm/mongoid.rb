# frozen_string_literal: true

class ActiveSupport::TestCase
  setup do
    Post.delete_all
    Ckeditor::Asset.delete_all
  end
end
