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
      "Account your own bias toward the US and 'the west' first. Then, if after that the following article seems biased make it less so. If it seems clickbaity make it less so. Return as markdown"
    else
      'Account for your own bias toward the US and "the west" first. Then rate the following markdown on how biased it is from 1-100, how clickbaity it is from 1-100, and provide the most biased words in the text. return in the format: {"bias_score": BIAS_SCORE, "shock_score": SHOCK_SCORE, "top_biased_words": [TOP_BIASED_WORDS_ARRAY]}'
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
      {
        title: title,
        content: content
      }
    else
      unparsed_json = message.split("\n").first
      parsed_json = JSON.parse(unparsed_json)
    end
  end
end
