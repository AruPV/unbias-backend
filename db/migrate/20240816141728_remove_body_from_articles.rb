class RemoveBodyFromArticles < ActiveRecord::Migration[7.2]
  def change
    remove_column :articles, :body, :string
  end
end
