require 'test_helper'

class CkeditorTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Ckeditor
  end
  
  test 'setup block yields self' do
    Ckeditor.setup do |config|
      assert_equal Ckeditor, config
    end
  end
  
  test "relative public path" do
    Ckeditor.path = 'public/javascripts'
    
    assert_equal Ckeditor.path, 'public/javascripts'
    assert_equal Ckeditor.relative_path, '/javascripts'
  end
  
  test "custom relative public path" do
    Ckeditor.path = 'public/assets'
    
    assert_equal Ckeditor.path, 'public/assets'
    assert_equal Ckeditor.relative_path, '/assets'
  end
end
