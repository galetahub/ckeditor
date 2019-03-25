# frozen_string_literal: true

class CreatePosts < ActiveRecord::Migration[5.2]
  def up
    create_table :posts do |t|
      t.string :title
      t.text :info
      t.text :content
      t.timestamps null: false
    end
  end

  def down
    drop_table :posts
  end
end
