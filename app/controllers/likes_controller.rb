class LikesController < ApplicationController
  before_action :find_article_version
  before_action :find_user

  def create
    is_like = params[:isLike]
    @article_version.votes.create(user_id_clerk: user_id, is_like: is_like)
  end

  def destroy
    if ()
    end
  end

  private

  def find_article
    @article_version = ArticleVersion.where("url = ?", url).first
  end

  def find_user
    @user_id = clerk_user["id"]
  end

  def already_voted?
    user_id = clerk_user["id"]
    Vote.where(user_id_clerk: user_id, article_id: @article.id)
  end
end
