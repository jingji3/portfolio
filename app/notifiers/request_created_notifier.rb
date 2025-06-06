class RequestCreatedNotifier < Noticed::Event
  # 個別配信でデータベースに保存
  deliver_by :database

  # 必要なパラメータ
  required_params :character_names, :character_ids

  # レコードのバリデーション
  validates :record, presence: true

  # 直接メソッドを定義（notification_methodsブロック不要）
  def title
    "おすすめ動画リクエストがありました"
  end

  def message
    character_list = params[:character_names].join("、")
    "#{character_list}のおすすめ動画リクエストがありました\n#{record.message}"
  end

  def url
    # character_ids配列をURLパラメータとして渡す
    character_ids = params[:character_ids]
    query_params = { character_ids: character_ids }
    Rails.application.routes.url_helpers.new_post_path(query_params)
  end
end
