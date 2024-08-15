class Article < ApplicationRecord
  belongs_to :user
  belongs_to :original, class_name: "Article", optional: true

  def process(url)
    doc = Nokogiri.HTML5(URI.open(url))
    title = doc.xpath("//h1").first
    article = doc.xpath("//h2 or //h3 or //h4 or //h5 or //h6 or //p")

    { title: title, article: article }
  end
end
