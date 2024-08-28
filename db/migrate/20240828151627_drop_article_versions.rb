class DropArticleVersions < ActiveRecord::Migration[7.2]
  def up
    drop_table :article_versions, force: :cascade
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
