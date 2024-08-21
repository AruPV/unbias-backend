require "open-uri"

class ArticlesController < ApplicationController
  before_action :set_article, only: %i[ show update destroy ]

  # GET /articles
  def index
    render json: Article.latest_articles
  end

  # GET /articles/1
  def show
    render json: @article
  end

  def handle_fetch(url)
  end

  # POST /articles
  def create
    is_unbias = params[:unbias]
    url = params[:url]
    user_id = clerk_user["id"]
    article = Article.where("url = ?", url).first

    # If URL not in DB
    if article == nil               # Honestly, this logic should be elsewhere
      puts("Article not found in DB")
      begin
        # Create Article
        puts("Creating Article")
        article = Article.new(UrlHandler.call(url))
        # Update Article before commit to db
        article[:user_id] = user_id
        llm_json = Llm.call(article, false)
        article[:top_biased_words] = llm_json["top_biased_words"]
        article[:shock_score] = llm_json["shock_score"]
        article[:bias_score] = llm_json["bias_score"]
        article.save
        # Create ArticleVersion and update article record
        article_version = ArticleVersion.new(original_id: article[:id], user_id: user_id)
        article_version.save
        puts("Updating the record in db for articles to have:")
        puts(article_version[:id])
        article.update(article_version_id: article_version[:id])
        puts("Updated the record in db for the article. Now is:")
        puts(article[:id])
      rescue => error
        puts("Error")
        render status: error    # !!! Handle errors individually before production
        return
      end
    end

    puts("Article found")
    if !is_unbias
      render json: article.generate_json
      return
    end

    article_version = ArticleVersion.find(article[:article_version_id])

    if article_version[:unbiased_id] != nil
      article = Article.find(article_version[:unbiased_id])
      render json: article.generate_json
      return
    end

    puts("Generating new unbiased version")
    llm_response = Llm.call(article, true)
    new_article = Article.new(llm_response)
    llm_json = Llm.call(new_article, false)
    new_article[:top_biased_words] = llm_json["top_biased_words"]
    new_article[:shock_score] = llm_json["shock_score"]
    new_article[:bias_score] = llm_json["bias_score"]
    new_article.save
    article_version.update(unbiased_id: new_article[:id])
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
