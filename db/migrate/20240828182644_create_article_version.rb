class CreateArticleVersion < ActiveRecord::Migration[7.2]
  def change
    create_table :article_versions do |t|
      t.belongs_to :article, null: false, foreign_key: true
      t.string :title
      t.string :content
      t.integer :bias_score
      t.integer :shock_score
      t.string :top_biased_words, array: true, default: []

      t.timestamps
    end
  end
end
