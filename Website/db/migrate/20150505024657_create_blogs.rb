class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title, limit: 60, null: false
      t.text :body, null: false
      t.datetime :top
      
      t.references :user

      t.timestamps null: false
    end
  end
end
