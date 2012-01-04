require 'test_helper'

class PostsTest < ActiveSupport::IntegrationCase
  def setup
    @post = Post.create!(:title => "test", :content => "content", :info => "info")
  end
  
  def teardown
    @post.destroy
  end
  
  test "include javascripts" do
    visit(posts_path)
    
    assert page.body.include?('/assets/application.js')
    assert page.body.include?("CKEDITOR.replace('test_area', { language: 'en' });")
  end
  
  test "pass text_area with options" do
    visit(posts_path)
    
    assert page.body.include?('<textarea cols="10" id="content" name="content" rows="20">Ckeditor</textarea>')
    assert page.body.include?("CKEDITOR.replace('content', { language: 'en',toolbar: 'Easy' });")
  end
  
  test "form builder helper" do
    visit(new_post_path)
    
    assert page.body.include?('<textarea cols="40" id="post_content" name="post[content]" rows="20"></textarea>')
    assert page.body.include?("CKEDITOR.replace('post_content', { height: 400,language: 'en',width: 800 });")
    assert page.body.include?('<textarea cols="40" id="post_info" name="post[info]" rows="20">Defaults info content</textarea>')
    assert page.body.include?("CKEDITOR.replace('post_info', { language: 'en' });")
  end
  
  test "text_area value" do
    visit(edit_post_path(@post))
    
    assert page.body.include?('<textarea cols="40" id="post_content" name="post[content]" rows="20">content</textarea>')
    assert page.body.include?('<textarea cols="50" id="post_info" name="post[info]" rows="70">info</textarea>')
  end
end
