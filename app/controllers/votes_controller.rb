class VotesController < ApplicationController
  before_action :find_article
  # before_action :find_user

  def index
    render json:
  end

  def create
    user_id = 1
    is_like = params[:isLike]
    vote = @article.votes.create(vote_params)
    if vote.save
      render json: @article.total_votes
    else
      render json: vote.errors, status: 400
    end
  end

  def destroy
  end

  def destroy
    if ()
    end
  end

  private
  def vote_params
    params.require(:vote).permit(:user_id, :is_like)
  end

  def find_article
    @article = Article.find(params[:article_id])
  end

  def find_user
    @user_id = clerk_user["id"]
  end

=begin
  def already_voted?
    user_id = clerk_user["id"]
    Vote.where(user_id_clerk: user_id, article_id: @article.id)
  end
=end
end
