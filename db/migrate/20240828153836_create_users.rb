class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :clerk_id
      t.string :display_name

      t.timestamps
    end
  end
end
