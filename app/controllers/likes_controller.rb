class LikesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    like = current_user.likes.new(post_id: post.id)
    variant = params[:variant]&.to_sym || :medium #variantを取得

    respond_to do |format|
      if like&.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("post_#{post.id}_like", partial: 'posts/like_btn', locals:{ post: post, variant: variant })
        end
      else
        format.html { redirect_to posts_path, alert: 'いいねできませんでした' }
      end
    end
  end

  def destroy
    post = Post.find(params[:post_id])
    like = current_user.likes.find_by(post_id: post.id)
    variant = params[:variant]&.to_sym || :medium #variantを取得

    respond_to do |format|
      if like&.destroy
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("post_#{post.id}_like", partial: 'posts/like_btn', locals:{ post: post, variant: variant })
        end
      else
        format.html { redirect_to posts_path, alert: 'いいね解除できませんでした' }
      end
    end
  end
end
