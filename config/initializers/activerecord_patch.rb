require "logger"

if Rails.gem_version < Gem::Version.new("7.1.0")
  # Rails 7.0系の場合の対応
  # logger gemをロードするだけでOK
else
  # Rails 7.1系の場合の対応
  ActiveSupport.on_load(:active_record) do
    class ActiveRecord::Base
      class << self
        def attributes_for_inspect=(val)
          # 空実装
        end
      end
    end
  end
end
