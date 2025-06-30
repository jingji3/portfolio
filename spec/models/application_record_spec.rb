require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  context '.human_enum_name' do
    it 'enumの翻訳名を返す' do
      enum_result = Character.human_enum_name(:element, :Pyro)
      expect(enum_result).to eq('炎')
    end
  end
end
