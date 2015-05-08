class CreateLanguageProblemTypeShips < ActiveRecord::Migration
  def change
    create_table :language_problem_type_ships do |t|
      t.references :language
      t.references :problem_type

      t.timestamps null: false
    end
  end
end
