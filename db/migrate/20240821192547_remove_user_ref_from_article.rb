class RemoveUserRefFromArticle < ActiveRecord::Migration[7.2]
  def change
    remove_reference :articles, :user, null: false, foreign_key: true
  end
end
