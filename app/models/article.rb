class Article < ApplicationRecord
  belongs_to :user
  has_many :article_versions, dependent: :destroy
  has_many :votes, dependent: :destroy

  # Instance variables:
  # @url [string]
  # @user_id [bigint]

  def new_version(is_unbias)
    parsed_article = UrlHandler.call(self.url)
    puts(parsed_article)

    if is_unbias then
      parsed_article = Llm.call(parsed_article, true)
    end

    article_metrics = Llm.call(parsed_article, false)
    title = parsed_article[:title]
    content = parsed_article[:content]
    top_biased_words = article_metrics["top_biased_words"]
    shock_score = article_metrics["shock_score"]
    bias_score = article_metrics["bias_score"]

    article_versions.create(
      title: title,
      content: content,
      top_biased_words: top_biased_words,
      shock_score: shock_score,
      bias_score: bias_score
    )
  end

  def total_votes
    self.votes.sum do |vote|
      { true=>1, false=>-1, nil=>0 }[vote&.is_like]
    end
  end

  def self.latest_articles(limit = 10)
    latest_articles = Article.last(limit).reverse.map do |article|
      article.retrieve_versions
    end
  end

  def retrieve_versions
    {
      id: self.id,
      vote_total: self.total_votes,
      original: self.article_versions.first&.generate_json,
      unbiased: self.article_versions.last&.generate_json
    }
  end
end
