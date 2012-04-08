require 'test_helper'

class AttachmentFileTest < ActiveSupport::TestCase
  test "Set file content_type and size" do
    @attachment = create_attachment
    
    # TODO: fix filename parameterization
    if CKEDITOR_BACKEND == :paperclip
      assert_equal @attachment.data_file_name, "rails_tar.gz"
    else
      assert_equal @attachment.data_file_name, "rails.tar.gz"
    end
    
    assert_equal @attachment.data_content_type, "application/x-gzip"
    assert_equal @attachment.data_file_size, 6823
    assert_equal @attachment.url_thumb, "/assets/ckeditor/filebrowser/images/thumbs/gz.gif"
  end
end
