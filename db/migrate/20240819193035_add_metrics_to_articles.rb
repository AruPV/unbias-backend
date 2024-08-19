class AddMetricsToArticles < ActiveRecord::Migration[7.2]
  def change
    add_column :articles, :bias_score, :integer
    add_column :articles, :shock_score, :integer
    add_column :articles, :top_biased_words, :string, array: true, default: []
  end
end
