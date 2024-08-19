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

  def handle_fetch(url)
  end

  # POST /articles
  def create
    url = params[:url]        # !!! No auth
    is_unbias = params[:unbias]
    user_id = 1               # !!! Change when auth
    article = Article.where("url = ?", url).first

    # If URL not in DB
    if article == nil
      begin
        article = Article.new(UrlHandler.call(url))
        article[:user_id] = user_id
        article.save
      rescue => error
        render status: error    # !!! Handle errors individually before production
        return
      end
    end

    if !is_unbias
      render json: article.generate_json
      return
    end

    if article.unbiased_id != nil
      article = Article.find(article.unbiased_id)
      render json: article.generate_json
      return
    end

    llm_response = Llm.call(article)
    new_article = Article.new(llm_response)
    new_article.save
    article[:unbiased_id] = new_article.id
    render json: new_article.generate_json()
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
