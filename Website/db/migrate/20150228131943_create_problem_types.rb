class CreateProblemTypes < ActiveRecord::Migration
  def change
    create_table :problem_types do |t|
    	t.string :title, limit: 55, null: false

      t.timestamps null: false
    end
  end
end
