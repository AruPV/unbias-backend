class DropArticleTable < ActiveRecord::Migration[7.2]
  def up
    drop_table :articles, force: :cascade
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
