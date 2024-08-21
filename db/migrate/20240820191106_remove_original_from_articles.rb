class RemoveOriginalFromArticles < ActiveRecord::Migration[7.2]
  def change
    remove_reference :articles, :original, null: false, foreign_key: { to_table: :articles }
  end
end
