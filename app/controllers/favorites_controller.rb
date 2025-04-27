class FavoritesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.new(post_id: @post.id)
    @variant = params[:variant]&.to_sym || :medium #variantを取得
    @favorite.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post_id: @post.id)
    @variant = params[:variant]&.to_sym || :medium #variantを取得
    @favorite&.destroy
  end
end
