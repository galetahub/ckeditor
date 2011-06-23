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
end
