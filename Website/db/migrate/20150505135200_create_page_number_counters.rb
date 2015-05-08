class CreatePageNumberCounters < ActiveRecord::Migration
  def change
    create_table :page_number_counters do |t|
      t.string :path, limit: 50, null: false
      t.integer :times, default: 0, null: false

      t.timestamps null: false
    end
  end
end
