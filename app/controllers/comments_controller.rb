class CommentsController < ApplicationController
  before_action :set_comment, only: %i[destroy edit update cancel]
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.build(comment_params)
    @comment.post = @post

    if @comment.parent_id.present?
      parent_comment = Comment.find(@comment.parent_id)
      @comment.parent_id = parent_comment.parent_id if parent_comment.parent_id.present?
    end

    @comment.save
  end

  def destroy
    @comment.destroy!
  end

  def edit; end

  def update
    # コメントから投稿IDを取得して params に設定
    params[:post_id] = @comment.post_id

    if @comment.update(comment_params)
    # 成功時は何もしない（update.turbo_stream.erbが自動的にレンダリングされる）
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def cancel; end

  private

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  # 作成用のストロングパラメータ
  def comment_params
    params.require(:comment).permit(:comment, :parent_id).merge(post_id: params[:post_id])
  end
end
