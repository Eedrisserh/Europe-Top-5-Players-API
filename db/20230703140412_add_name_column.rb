class AddNameColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string


    add_index :users, :uid
    add_index :users, [:provider, :uid]
  end
end
