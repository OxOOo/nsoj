class CreateStatistics < ActiveRecord::Migration
  	def change
    		create_table :statistics do |t|
			t.integer :solved_count, defualt: 0, null: false
			t.integer :accepted_count, defualt: 0, null: false
			t.integer :submission_count, defualt: 0, null: false
			t.belongs_to :statistic_table, polymorphic: true

      			t.timestamps null: false
    		end
  	end
end
