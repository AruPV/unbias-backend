class RemoveArticleVersionFromArticle < ActiveRecord::Migration[7.2]
  def change
    remove_reference :articles, :article_versions, null: false, foreign_key: { to_table: :article_versions }
  end
end
