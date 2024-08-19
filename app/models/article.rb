class Article < ApplicationRecord
  belongs_to :user
  belongs_to :original, class_name: "Article", optional: true
  belongs_to :unbiased, class_name: "Article", optional: true

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
end
