class CreateClientIps < ActiveRecord::Migration
  def change
    create_table :client_ips do |t|
      t.string :ip, limit: 30, null: false
      t.datetime :last_login
      
      t.references :user

      t.timestamps null: false
    end
  end
end
