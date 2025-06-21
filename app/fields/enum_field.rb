require "administrate/field/base"

class EnumField < Administrate::Field::Base
  def to_s
    if data.present?  # データが存在する場合
      # resource = 対象のモデルインスタンス（例: @user）
      # attribute = フィールド名（例: :role）
      # data = 実際の enum 値（例: "admin"）
      resource.class.human_enum_name(attribute, data)
      # ↓
      # User.human_enum_name(:role, "admin") → "管理者"
    else
      data  # データがない場合はそのまま表示
    end
  end

  # フィールドの値を取得
  def collection
    resource.class.enum_options_for_select(attribute)
  end
  # 実行例:
  # User.enum_options_for_select(:role)
  # → [["管理者", "admin"], ["一般会員", "general"]

  # フォームで使用する属性のキー
  def attribute_key
    attribute
  end

  # フォームで使用する属性の表示名
  def attribute_name
    resource.class.human_attribute_name(attribute)
  end
end
