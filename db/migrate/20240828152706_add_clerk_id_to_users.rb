class AddClerkIdToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :clerk_id, :string
  end
end
