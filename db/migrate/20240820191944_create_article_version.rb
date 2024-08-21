class CreateArticleVersion < ActiveRecord::Migration[7.2]
  def change
    create_table :article_versions do |t|
      t.references :original, null: false, foreign_key: { to_table: :articles }
      t.references :unbiased, null: false, foreign_key: { to_table: :articles }

      t.timestamps
    end
  end
end
