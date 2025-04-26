class FavoritesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.new(post_id: post.id)
    variant = params[:variant]&.to_sym || :medium #variantを取得

    respond_to do |format|
      if favorite&.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("post_#{post.id}_favorite", partial: 'posts/favorite_btn', locals:{ post: post, variant: variant })
        end
      else
        format.html { redirect_to posts_path, alert: 'お気に入りできませんでした' }
      end
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = current_user.favorites.find_by(post_id: post.id)
    variant = params[:variant]&.to_sym || :medium #variantを取得

    respond_to do |format|
      if favorite&.destroy
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("post_#{post.id}_favorite", partial: 'posts/favorite_btn', locals:{ post: post, variant: variant })
        end
      else
        format.html { redirect_to posts_path, alert: 'お気に入り解除できませんでした' }
      end
    end
  end
end
