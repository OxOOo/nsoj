class CreateOnlineJudges < ActiveRecord::Migration
  def change
    create_table :online_judges do |t|
      t.string :name, limit: 30, null: false
      t.string :description, limit: 210
      t.string :address, limit: 50, null: false
      t.string :regexp, limit: 30, null: false
      t.string :hint, limit: 50
      t.string :default, limit: 50, null: false

      t.timestamps null: false
    end
  end
end
