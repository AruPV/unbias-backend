class AddUnbiasedRefToArticle < ActiveRecord::Migration[7.2]
  def change
    add_reference :articles, :unbiased, foreign_key: { to_table: :users }
  end
end
