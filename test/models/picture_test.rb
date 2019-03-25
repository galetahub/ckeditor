# frozen_string_literal: true

require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  def teardown
    @picture.destroy rescue nil
  end

  test 'Set file content_type and size' do
    @picture = create_picture

    assert_equal 'rails.png', @picture.data_file_name
    assert_equal 6646, @picture.data_file_size

    if CKEDITOR_BACKEND == :dragonfly
      assert @picture.url_thumb.include?('thumb_rails')
    else
      assert @picture.url_thumb.include?('thumb_rails.png')
    end
  end
end
