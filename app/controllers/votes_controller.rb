class VotesController < ApplicationController
  before_action :find_article
  before_action :find_user
  before_action :find_vote, only: [ :destroy ]

  # GET articles/vote
  def show
    render json: @article.total_votes
  end

  # POST articles/vote
  def create
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
    vote_id = @article.find_vote_by_user(@user_id)
    if vote_id == nil
      vote = @article.votes.create(vote_params)
      if vote.save
        render json: vote
      else
        render json: vote.errors, status: 400
      end
      return
    end

    vote = Vote.find(vote_id)
    if vote.update(vote_params)
      render json: vote
    else
      render json: vote.errors, status: :unprocessable_entity
    end
  end

  private #####################################################################

  def find_article
    @article = Article.find(params[:article_id])
    puts(@article)
    if @article == nil
      render response: 404
    end
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
