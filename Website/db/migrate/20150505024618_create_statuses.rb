class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :name, limit: 30, null: false
      t.string :style, limit: 30

      t.timestamps null: false
    end
  end
end
