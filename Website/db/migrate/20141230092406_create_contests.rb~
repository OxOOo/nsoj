class CreateContests < ActiveRecord::Migration
  	def change
    		create_table :contests do |t|
			t.string :name, limit: 60, null: false
			t.text :description, limit: 1010, null: false
			t.datetime :start_time, null: false
			t.datetime :end_time, null: false
			t.boolean :hide_problem, defualt: true, null: false
			t.references :contest_type
			t.references :course
			t.references :user

      			t.timestamps null: false
    		end
  	end
end
