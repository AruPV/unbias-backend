require "open-uri"

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show update destroy ]
  before_action :get_user

  # GET /articles
  def index
    render json: Article.latest_articles(@user.id)
  end

  # GET /articles/1
  def show
    render json: @article
  end

  # POST /articles
  def create
    is_unbias = params[:unbias]
    url = params[:url]

    article = Article.where("url = ?", url).first
    if article == nil
      begin
        article = Article.create(url: url, user: @user)
      rescue => error
        render status: error
        return
      end
    end

    original = article.article_versions.first
    if original == nil
      begin
        original = article.new_version(false)
      rescue => error
        render status: error
        return
      end
    end

    if !is_unbias
      render json: original.generate_json
      return
    end

    unbiased = article.article_versions.last
    if unbiased == original then
      begin
        unbiased = article.new_version(true)
      rescue => error
        render status: error
        return
      end
    end

    render json: unbiased.generate_json
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

    def get_user
      if !clerk_user
        render status: 401
        return
      end
      @user = User.where("clerk_id = ?", clerk_user["id"]).first
    end

    # Only allow a list of trusted parameters through.
    def article_params
      params.require(:article).permit(:url, :user_id)
    end
end
