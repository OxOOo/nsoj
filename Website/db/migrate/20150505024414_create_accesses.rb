class CreateAccesses < ActiveRecord::Migration
  def change
    create_table :accesses do |t|
      t.boolean :is_root, default: false, null: false
      t.boolean :is_admin, default: false, null: false
      t.boolean :can_add_problem, default: false, null: false
      t.boolean :can_modify_problem, default: false, null: false
      t.boolean :can_add_contest, default: false, null: false
      t.boolean :can_modify_contest, default: false, null: false
      t.boolean :can_watch_code, default: false, null: false
      
      t.references :user

      t.timestamps null: false
    end
  end
end
