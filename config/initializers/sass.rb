if defined?(SassC)
  # SassCの設定をオーバーライド
  module SassC
    module Script
      module Functions
        # rgbメソッドをオーバーライドして新しい構文をサポート
        def rgb(r, g = nil, b = nil)
          if g.nil? && r.to_s.include?('/')
            # 新しい構文をそのまま通す
            return SassC::Script::Value::String.new("rgb(#{r.to_s})", :identifier)
          end

          # 通常の処理
          SassC::Script::Value::Color.new([r.value, g.value, b.value])
        end
      end
    end
  end
end
