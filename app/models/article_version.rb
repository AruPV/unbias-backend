class ArticleVersion < ApplicationRecord
  belongs_to :article

  # Instance Variables
  # @article_id       [bigint]
  # @title            [string]
  # @content          [string]
  # @bias_score       [integer]
  # @shock_score      [integer]
  # @top_biased_words [[]string]

  def generate_json
    response_title = "<h1>#{self.title}</h1>"
    response_content = Commonmarker.to_html(self.content)  # !!! Cache this?

    response_json = {
      title: response_title,
      content: response_content,
      shock_score: self.shock_score,
      bias_score: self.bias_score,
      top_biased_words: self.top_biased_words
    }
  end

  private
end
