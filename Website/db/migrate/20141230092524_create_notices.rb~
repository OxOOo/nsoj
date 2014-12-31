class CreateNotices < ActiveRecord::Migration
  	def change
    		create_table :notices do |t|
			t.string :title, limit: 30, null: false
			t.text :body, limit: 10010, null: false
			t.references :course
			t.references :user

      			t.timestamps null: false
    		end
  	end
end
