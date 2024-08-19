class Llm
  def initialize(article, is_unbias)
    @key = ENV.fetch("OPENAI_API_KEY") # UNSAFE
    @article = article
    @is_unbias = is_unbias
  end

  def self.call(article, is_unbias)
    new(article, is_unbias).call
  end

  def call
    prompt =
    if @is_unbias then
      "Return a markdown from a markdown. If something seems alarmist, tone it down. If something seems like they're trying to undersell something that has happened, tone it up. Be mindful of who the site aligns with internationally and correct for it. Also correct for your own algorithmic racism. minimize bias"
    else
      'Rate the following markdown on how biased it is from 1-100, how clickbaity it is from 1-100, and provide the most biased words in the text. return in the format: {"bias_score": BIAS_SCORE, "shock_score": SHOCK_SCORE, "top_biased_words": [TOP_BIASED_WORDS_ARRAY]}'
    end

    body = "# " + @article.title + "\n" + @article.content
    response = HTTP.auth("Bearer " + @key)
      .post("https://api.openai.com/v1/chat/completions", json: {
      model: "gpt-4o-mini",
      messages: [
        {
          role: "system",
          content: prompt
        },
        {
          role: "user",
          content: body
        }
      ]
    })

    message = response.parse["choices"].first["message"]["content"]
    if @is_unbias then
      title = message.split("\n").first
      content = message[title.length...]
      title = title[1...]
      { url: @article.url, title: title, content: content, user_id: @article.user_id, original_id: @article.id }
    else
      unparsed_json = message.split("\n").first
      puts(unparsed_json)
      terms_array = JSON.parse(unparsed_json)
    end
  end
end
