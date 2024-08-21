class AddUserIdToArticleVersion < ActiveRecord::Migration[7.2]
  def change
    add_column :article_versions, :user_id, :string
  end
end
