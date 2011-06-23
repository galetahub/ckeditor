class Post < ActiveRecord::Base
  validates_presence_of :title, :info, :content
end
