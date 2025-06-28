class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # Enumsの翻訳メソッド
  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.enums.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end
  # User.human_enum_name(:role, :admin) を実行した場合
  # 1. model_name.i18n_key → "user" になる
  # 2. enum_name.to_s.pluralize → "roles" になる（roleの複数形）
  # 3. enum_value → "admin" のまま

  # selectボックスの選択肢を取得
  def self.enum_options_for_select(enum_name)
    self.send(enum_name.to_s.pluralize).keys.map do |key|
      [ human_enum_name(enum_name, key), key ]
    end
  end
  # User.enum_options_for_select(:role) を実行した場合
  # 1. self.send("roles") → User.roles を実行
  # 2. User.roles.keys → ["admin", "general"] を取得
  # 3. 各keyに対してhuman_enum_nameを実行
end
