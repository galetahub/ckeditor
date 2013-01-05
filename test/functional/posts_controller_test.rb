require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def setup
    @post = Post.create!(:title => "test", :content => "content", :info => "info")
  end

  def teardown
    @post.destroy rescue nil
  end

  test "include javascripts" do
    get :index
    
    assert_select "script[src=/assets/application.js]"
    assert_select "script", Regexp.new(Regexp.escape(%q!CKEDITOR.replace('test_area', {"language":"en"});!))
  end

  test "pass text_area with options" do
    get :index

    assert_select "textarea#content[name=content][cols=10][rows=20]", "Ckeditor"
    assert_select "script", Regexp.new(Regexp.escape(%q!CKEDITOR.replace('content', {"language":"en","toolbar":"Easy"});!))
  end

  test "form builder helper" do
    get :new
    
    assert_select "textarea#post_content[name='post[content]'][cols=40][rows=20]", ""
    assert_select "script", Regexp.new(Regexp.escape(%q!CKEDITOR.replace('post_content', {"width":800,"height":400});!))
    assert_select "textarea#new_info_content[name='post[info]'][cols=40][rows=20]", "Defaults info content"
    assert_select "script", Regexp.new(Regexp.escape(%q!CKEDITOR.replace('new_info_content');!))
  end

  test "text_area value" do
    get :edit, :id => @post.id

    assert_select "textarea#post_content[name='post[content]'][cols=40][rows=20]", "content"
    assert_select "textarea#post_info[name='post[info]'][cols=50][rows=70]", "info"
  end
end
