class ArticleVersion < ApplicationRecord
  belongs_to :original, class_name: "Article"
  belongs_to :unbiased, class_name: "Article", optional: true
  after_destroy :destroy_associated

  def self.latest_articles
    ArticleVersion.all.map do |article_version|
      original = Article.find(article_version.original_id).generate_json
      unbiased =
        if article_version.unbiased_id == nil then {}
        else Article.find(article_version.unbiased_id).generate_json end
      { original: original, unbiased: unbiased }
    end
  end

  private
  def destroy_associated
    original.destroy
    unbiased.destroy
  end
end
