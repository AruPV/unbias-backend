class VotesController < ApplicationController
  before_action :find_article
  before_action :find_user
  before_action :find_vote, only: [ :update, :destroy ]

  # GET articles/vote
  def show
    render json: @article.total_votes
  end

  # POST articles/vote
  def create
    puts(vote_params)
    is_like = params[:isLike]
    vote = @article.votes.create(vote_params)
    if vote.save
      render json: vote.is_like
    else
      render json: vote.errors, status: 400
    end
  end

  # DELETE articles/vote
  def destroy
    @vote.destroy
  end

  # PATCH/PUT articles/vote
  def update
    Vote.find(vote_id).update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  private #####################################################################

  def find_article
    @article = Article.find(params[:article_id])
  end

  def find_user
    @user_id = User.where("clerk_id= ?", clerk_user["id"]).first.id
  end

  def find_vote
    @vote = Vote.find(@article.find_vote_by_user(@user_id))
    if @vote == nil
      render response: 404
    end
  end

  def vote_params
    params.require(:vote).permit(:is_like).merge(user_id: @user_id)
  end

=begin
  def already_voted?
    user_id = clerk_user["id"]
    Vote.where(user_id_clerk: user_id, article_id: @article.id)
  end
=end
end
