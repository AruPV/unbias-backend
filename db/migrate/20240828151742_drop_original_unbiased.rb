class DropOriginalUnbiased < ActiveRecord::Migration[7.2]
  def up
    drop_table :original_unbiaseds
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
