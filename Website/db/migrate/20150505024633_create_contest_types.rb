class CreateContestTypes < ActiveRecord::Migration
  def change
    create_table :contest_types do |t|
      t.string :name, limit: 30, null: false
      t.string :description, limit: 210, null: false

      t.timestamps null: false
    end
  end
end
