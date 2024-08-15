class Article < ApplicationRecord
  belongs_to :user
  belongs_to :original, class_name: "Article", optional: true

  def self.process(url)
    doc = Nokogiri.HTML5(URI.open(url))

    article = doc.css("article") ? doc.css("article") : doc.css("body")

    title_string = article.at("h1").to_s

    content = article.search("h2, h3, h4, h5, p")
    content.search("img, svg, circle, path, span, template").each(&:remove)
    content_string = content.to_s

    { title: title_string, content: content_string }
  end
end
