class CreateProblemTypeLanguageShips < ActiveRecord::Migration
  def change
    create_table :problem_type_language_ships do |t|
    	t.belongs_to :problem_type
    	t.belongs_to :language

      t.timestamps null: false
    end
  end
end
