require 'test_helper'

class PicturesControllerTest < ActionController::TestCase
  tests Ckeditor::PicturesController
  
  def setup
    @image = fixture_file_upload('files/rails.png', 'image/png')
  end
  
  test "index action" do
    get :index
    
    assert_equal 200, @response.status
    assert_template "ckeditor/pictures/index"
  end
  
  test "create action via filebrowser" do
    assert_difference 'Ckeditor::Picture.count' do
      post :create, :qqfile => @image
    end
    
    assert_equal 200, @response.status
  end
  
  test "create action via CKEditor upload form" do
    assert_difference 'Ckeditor::Picture.count' do
      post :create, :upload => @image, :CKEditor => 'ckeditor_field'
    end
    
    assert_equal 200, @response.status
  end
  
  test "invalid params for create action" do
    assert_no_difference 'Ckeditor::Picture.count' do
      post :create, :qqfile => nil
    end
  end
end
