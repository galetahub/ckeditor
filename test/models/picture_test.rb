# frozen_string_literal: true

require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  def teardown
    @picture.destroy rescue nil
  end

  test 'Set file content_type and size' do
    @picture = create_picture

    assert_equal 'rails.png', @picture.data_file_name unless CKEDITOR_BACKEND == :shrine
    case CKEDITOR_BACKEND
    when :dragonfly
      assert @picture.url_thumb.include?('thumb_rails')
    when :active_storage
      assert @picture.url_thumb =~ /\/representations\/.*\/rails.png/
    when :shrine
      assert @picture.url_thumb =~ /\S{32}\.png/
      assert @picture.data_file_name =~ /image_processing(\d{8})-(\d{5})-(\S{,7})\.png/
    else
      assert @picture.url_thumb.include?('thumb_rails.png')
    end

    assert_equal 6646, @picture.data_file_size
  end
end
