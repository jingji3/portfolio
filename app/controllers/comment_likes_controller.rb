class CommentLikesController < ApplicationController
  def create
    @comment = Comment.find(params[:comment_id])
    @comment_like = current_user.comment_likes.new(comment_id: @comment.id)
    @variant = params[:variant]&.to_sym || :medium
    @comment_like.save
  end

  def destroy
    @comment = Comment.find(params[:comment_id])
    @comment_like = current_user.comment_likes.find_by(comment_id: @comment.id)
    @variant = params[:variant]&.to_sym || :medium
    @comment_like.destroy
  end
end
