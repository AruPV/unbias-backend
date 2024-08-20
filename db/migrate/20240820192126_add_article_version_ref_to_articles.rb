class AddArticleVersionRefToArticles < ActiveRecord::Migration[7.2]
  def change
    add_reference :articles, :article_versions, null: false, foreign_key: true
  end
end
