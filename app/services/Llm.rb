class Llm
  def initialize(article)
    @article = article
  end

  def self.call(article)
    new(article).call
  end

  def call
    {
      title: @article.title,
      content: @article.content,
      url: @article.url,
      original_id: @article.id,
      user_id: @article.user_id
    }
  end
end
