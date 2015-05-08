class CreateConfigs < ActiveRecord::Migration
  def change
    create_table :configs do |t|
      t.string :name, limit: 50, null: false
      t.string :value, limit: 100
      t.string :description, limit: 100, null: false
      t.boolean :is_boolean, default: true, null: false
      t.boolean :is_integer, default: false, null: false

      t.timestamps null: false
    end
  end
end
