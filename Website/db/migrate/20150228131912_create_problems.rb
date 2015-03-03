class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
    	t.belongs_to :problem_type
    	
    	t.string :title, limit: 55, null: false
    	t.integer :time_limit, default: 0, null: false
    	t.integer :memory_limit, default: 0, null: false
    	t.integer :submit_limit, default: 0, null: false
    	t.integer :test_count, default: 10, null: false
    	t.boolean :show, default: false, null: false
    	t.boolean :judge, default: false, null: false

      t.timestamps null: false
    end
  end
end
