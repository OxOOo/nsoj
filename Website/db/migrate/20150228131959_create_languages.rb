class CreateLanguages < ActiveRecord::Migration
  def change
    create_table :languages do |t|
    	t.string :title, limit: 35, null: false

      t.timestamps null: false
    end
  end
end
