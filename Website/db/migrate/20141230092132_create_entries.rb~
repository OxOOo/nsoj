class CreateEntries < ActiveRecord::Migration
	def change
    		create_table :entries do |t|
			t.string :ip, limit: 30,null: false
			t.references :user

      			t.timestamps null: false
   		 end
  	end
end
