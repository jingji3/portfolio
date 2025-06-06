class RequestCompletedNotifier < Noticed::Event
  # 個別配信でデータベースに保存
  deliver_by :database

  # 必要なパラメータを修正（requestは不要）
  required_params :character_names, :character_ids

  # レコードのバリデーション（requestが必須）
  validates :record, presence: true

  def title
    "あなたのリクエストしたおすすめ動画がシェアされました"
  end

  def message
    character_list = params[:character_names].join("、")
    "#{character_list}のおすすめ動画がシェアされました"
  end

  def url
    character_ids = params[:character_ids]
    query_params = {}
    character_ids.each_with_index do |id, index|
      query_params["character#{index + 1}"] = id
    end

    Rails.application.routes.url_helpers.posts_path(query_params)
  end
end
