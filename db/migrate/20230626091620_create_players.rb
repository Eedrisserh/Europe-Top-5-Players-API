class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :name
      t.integer :age
      t.string :nationality
      t.string :place_of_birth
      t.string :position
      t.integer :shirt_no
      t.string :foot
      t.string :club
      t.string :agent
      t.string :league

      t.timestamps
    end
  end
end
