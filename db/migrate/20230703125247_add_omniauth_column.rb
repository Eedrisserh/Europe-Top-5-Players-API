class AddOmniauthColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :locked_at, :datetime
    add_column :users, :failed_attempts, :integer, default: 0, null: false

    add_index :users, :uid
    add_index :users, [:provider, :uid]
  end
end
