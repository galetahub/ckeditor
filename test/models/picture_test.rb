require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  test "Set file content_type and size" do
    @picture = create_picture
    
    assert_equal @picture.data_content_type, "image/png"
    assert_equal @picture.data_file_name, "rails.png"
    assert_equal @picture.data_file_size, 6646
    assert  @picture.url_thumb.include?('thumb_rails.png')
    
    if @picture.has_dimensions?
      assert_equal @picture.width, 50
      assert_equal @picture.height, 64
    end
  end
end
