class ChangeNullReferencesInArticleVersions < ActiveRecord::Migration[7.2]
  def change
    change_column_null :article_versions, :original_id, true
    change_column_null :article_versions, :unbiased_id, true
  end
end
