class Article < ApplicationRecord
  belongs_to :article_version, optional: true, dependent: :destroy

  def generate_json
    response_title = "<h1>#{self.title}</h1>"
    response_content = Commonmarker.to_html(self.content)  # !!! Cache this

    response_json = {
      title: response_title,
      content: response_content,
      shock_score: self.shock_score,
      bias_score: self.bias_score,
      top_biased_words: self.top_biased_words }
  end

  def self.latest_articles
    response = Article.all.map do |article|
      article.generate_json
    end.reverse
  end
end
