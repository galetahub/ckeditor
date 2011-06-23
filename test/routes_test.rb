require 'test_helper'

class CkeditorRoutingTest < ActionController::TestCase
  test "should route to pictures" do
    assert_generates "/ckeditor/pictures", { :controller => "ckeditor/pictures", :action => "index"}
    assert_generates "/ckeditor/pictures/1", { :controller => "ckeditor/pictures", :action => "destroy", :id => 1}
  end
  
  test "should route to attachment_files" do
    assert_generates "/ckeditor/attachment_files", { :controller => "ckeditor/attachment_files", :action => "index"}
    assert_generates "/ckeditor/attachment_files/1", { :controller => "ckeditor/attachment_files", :action => "destroy", :id => 1}
  end
  
  test 'map index pictures' do
    assert_named_route "/ckeditor/pictures", :ckeditor_pictures_path
    assert_recognizes({:controller=>"ckeditor/pictures", :action=>"index"}, {:path => '/ckeditor/pictures', :method => :get})
  end
  
  test 'map create picture' do
    assert_recognizes({:controller => 'ckeditor/pictures', :action => 'create'}, {:path => '/ckeditor/pictures', :method => :post})
  end
  
  test 'map destroy picture' do
    assert_named_route "/ckeditor/pictures/1", :ckeditor_picture_path, 1
    assert_recognizes({:controller => 'ckeditor/pictures', :action => 'destroy', :id => "1"}, {:path => '/ckeditor/pictures/1', :method => :delete})
  end
  
  test 'map index attachment_files' do
    assert_named_route "/ckeditor/attachment_files", :ckeditor_attachment_files_path
    assert_recognizes({:controller => 'ckeditor/attachment_files', :action => 'index'}, {:path => '/ckeditor/attachment_files', :method => :get})
  end
  
  test 'map create attachment_file' do
    assert_recognizes({:controller => 'ckeditor/attachment_files', :action => 'create'}, {:path => '/ckeditor/attachment_files', :method => :post})
  end
  
  test 'map destroy attachment_file' do
    assert_named_route "/ckeditor/attachment_files/1", :ckeditor_attachment_file_path, 1
    assert_recognizes({:controller => 'ckeditor/attachment_files', :action => 'destroy', :id => "1"}, {:path => '/ckeditor/attachment_files/1', :method => :delete})
  end
  
  protected

    def assert_named_route(result, *args)
      assert_equal result, @routes.url_helpers.send(*args)
    end
end
