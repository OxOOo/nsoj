class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.string :ip, limit: 30, null: false
      t.string :description, limit: 110, null: false

      t.references :user

      t.timestamps null: false
    end
  end
end
