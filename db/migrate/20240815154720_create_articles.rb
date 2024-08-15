class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :body
      t.string :url
      t.references :user, null: false, foreign_key: true
      t.references :original, foreign_key: { to_table: :articles }

      t.timestamps
    end
  end
end
