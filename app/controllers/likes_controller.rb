class LikesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @like = current_user.likes.new(post_id: @post.id)
    @variant = params[:variant]&.to_sym || :medium #variantを取得
    @like.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    @like = current_user.likes.find_by(post_id: @post.id)
    @variant = params[:variant]&.to_sym || :medium #variantを取得
    @like&.destroy
  end
end
