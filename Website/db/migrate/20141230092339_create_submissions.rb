class CreateSubmissions < ActiveRecord::Migration
  	def change
    		create_table :submissions do |t|
			t.integer :time, default: 0, null: false
			t.integer :memory, default: 0, null: false
			t.string :submit_ip, limit: 30, null: false
			t.integer :score, default: 0, null: false
			t.integer :source_length, default: 0, null: false
			t.integer :submission_score, default: 0, null: false
			t.integer :task, default: 0, null: false
			t.references :user_course_ship
			t.references :statistic
			t.references :language
			t.references :status
			t.references :environment_type

      			t.timestamps null: false
    		end
  	end
end
