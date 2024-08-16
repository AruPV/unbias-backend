class Article < ApplicationRecord
  belongs_to :user
  belongs_to :original, class_name: "Article", optional: true

  def self.process(url)
    puts("HTTP Request")
    response = HTTP.get(url)
    doc = Nokogiri.HTML5(response)

    puts("Received:")

    puts("Getting Article")
    article = doc.css("body")
    puts(article)
    puts("Articled")

    title_string = article.at("h1").inner_html

    puts(title_string)

    content = article.search("h2, h3, h4, h5, p")
    content.search("img, svg, circle, path, span, template, small, script").each(&:remove)
    content_string = content.to_s
    content_markdown = ReverseMarkdown.convert content_string

    { title: title_string, content: content_markdown }
  end
end
