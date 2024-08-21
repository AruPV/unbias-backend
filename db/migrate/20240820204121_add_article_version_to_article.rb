class AddArticleVersionToArticle < ActiveRecord::Migration[7.2]
  def change
    add_reference :articles, :article_version, null: true, foreign_key: true
  end
end
