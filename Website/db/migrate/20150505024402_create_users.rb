class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, limit: 30, null: false
      t.string :password, limit: 40, null: false
      t.string :nickname, limit: 30
      t.string :sign, limit: 110
      t.string :create_ip, limit: 30, null: false
      t.datetime :last_online
      t.integer :solved_count, default: 0, null: false
      t.integer :accepted_count, default: 0, null: false
      t.integer :submissions_count, default: 0, null: false

      t.timestamps null: false
    end
  end
end
