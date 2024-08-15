require "open-uri"

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show update destroy ]

  # GET /articles
  def index
    @articles = Article.all

    render json: @articles
  end

  # GET /articles/1
  def show
    render json: @article
  end

  # POST /articles
  def create
    url = params[:url]
    doc = Nokogiri.HTML5(URI.open(url))
    article_title = doc.css("h1").first.to_s
    puts(article_title)
    article_body = doc.css("h2, h3, h4, h5, p")
    article_body.search("img, svg, circle, path, span, template").each(&:remove)
    article_body = article_body.to_s
    puts(article_body)
    article = { article_title: article_title, article_body: article_body }
    puts(article)
    render json: article
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:title, :body, :url, :user_id, :original_id)
    end
end
