# Rails 7.1とRuby 3.2の互換性問題に対する修正
module ActiveRecordAttributesInspectPatch
  def self.apply
    ActiveSupport.on_load(:active_record) do
      unless ActiveRecord::Base.respond_to?(:attributes_for_inspect=)
        ActiveRecord::Base.class_eval do
          def self.attributes_for_inspect=(val)
            # この空のメソッド定義により、メソッド不在のエラーを回避
          end
        end
      end
    end
  end
end

ActiveRecordAttributesInspectPatch.apply
