require 'test_helper'

class AttachmentFileTest < ActiveSupport::TestCase
  def teardown
    @attachment.destroy rescue nil
  end

  test 'Set file content_type and size' do
    @attachment = create_attachment

    assert_equal "rails.tar.gz", @attachment.data_file_name

    assert_match /application\/(x-)?gzip/, @attachment.data_content_type
    assert_equal 6823, @attachment.data_file_size
    assert_equal "ckeditor/filebrowser/thumbs/gz.gif", @attachment.url_thumb
  end
end
