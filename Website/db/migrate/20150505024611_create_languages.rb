class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
      t.string :name, limit: 20, null: false
      t.string :cmd, limit: 100, null: false

      t.timestamps null: false
    end
  end
end
