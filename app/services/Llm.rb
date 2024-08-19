class Llm
  def initialize(article)
    @key = ENV.fetch("OPENAI_API_KEY") # UNSAFE
    @article = article
  end

  def self.call(article)
    new(article).call
  end

  def call
    body = "# " + @article.title + "\n" + @article.content
    response = HTTP.auth("Bearer " + @key)
      .post("https://api.openai.com/v1/chat/completions", json: {
      model: "gpt-4o-mini",
      messages: [
        {
          role: "system",
          content: "Return a markdown from a markdown. If something seems alarmist, tone it down. If something seems like they're trying to undersell something that has happened, tone it up. Be mindful of who the site aligns with internationally and correct for it"
        },
        {
          role: "user",
          content: body
        }
      ]
    })
    message = response.parse["choices"].first["message"]["content"]
    title = message.split("\n").first
    content = message[title.length...]
    title = title[1...]

    { url: @article.url, title: title, content: content, user_id: @article.user_id, original_id: @article.id }
  end
end
