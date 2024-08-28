class Article < ApplicationRecord
  has_many :article_versions, dependent: :destroy
  belongs_to :user

  # Instance variables:
  # @url [string]
  # @user_id [bigint]

  def new_version(is_unbias)
    parsed_article = UrlHandler.call(@url)

    if !is_unbias then
      parsed_article = Llm.call(unbiased_article, true)
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

=begin
  def self.latest_articles
    Article.all.map do |article|
      original = ArticleVerion.find(article.original_id).generate_json
      unbiased =
        if article_version.unbiased_id == nil then {}
        else Article.find(article_version.unbiased_id).generate_json end
      { original: original, unbiased: unbiased }
    end
  end

  def retrieve_versions
    @article_versions.map do |article_version|
    end
  end
=end
end
