class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :message, null: false
      t.boolean :read, default: false, null: false
      
      t.references :sender
      t.references :receiver

      t.timestamps null: false
    end
  end
end
