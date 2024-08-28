class UrlHandler
  def initialize(url)
    @url = url
  end

  def self.call(url)
    new(url).call
  end

  def call
    response = HTTP.get(@url)
    doc = Nokogiri.HTML5(response)
    puts(doc)
    article = doc.css("body")

    title_string = article.at("h1").inner_html

    content = article.search("h2, h3, h4, h5, p")
    content.search("img, svg, circle, path, span, template, small, script").each(&:remove)
    content_string = content.to_s
    content_markdown = ReverseMarkdown.convert content_string

    { title: title_string, content: content_markdown }
  end
end
