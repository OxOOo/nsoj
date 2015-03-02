class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :username, limit: 35, null: false
    	t.string :password, limit: 35, null: false
    	t.boolean :admin, default: false, null: false

      t.timestamps null: false
    end
  end
end
