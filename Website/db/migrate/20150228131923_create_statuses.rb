class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
    	t.belongs_to :problem
    	t.belongs_to :user
    	t.belongs_to :language
    	
    	t.integer :score, default: 0, null: false
    	t.integer :time, default: 0, null: false
    	t.integer :memory, default: 0, null: false
    	t.integer :size, default: 0, null: false
    	t.boolean :task, default: false, null: false
    	t.boolean :finish, default: false, null: false

      t.timestamps null: false
    end
  end
end
