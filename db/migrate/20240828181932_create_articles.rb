class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.string :url
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
