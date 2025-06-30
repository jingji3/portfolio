require 'rails_helper'

RSpec.describe Request, type: :model do
  let(:request) { build(:request) }

  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      request = build(:request)
      expect(request).to be_valid
    end
  end

  context 'バリデーション' do
    context 'メッセージが500文字を超える場合' do
      it '無効であること' do
        request = build(:request, message: 'a' * 501)
        expect(request).not_to be_valid
      end
    end
  end

  context 'enum status' do
    it 'pending が動作する' do
      request.pending!
      expect(request.pending?).to be_truthy
    end

    it 'completed が動作する' do
      request.completed!
      expect(request.completed?).to be_truthy
    end

    it 'canceled が動作する' do
      request.canceled!
      expect(request.canceled?).to be_truthy
    end
  end

  context '#character_names' do
    it 'キャラクター名を文字列で返す' do
      character1 = create(:character, name: 'キャラA')
      character2 = create(:character, name: 'キャラB')
      create(:request_to_character, request: request, character: character1)
      create(:request_to_character, request: request, character: character2)

      expect(request.character_names).to eq('キャラA, キャラB')
    end

    it 'キャラクターがない場合は空文字' do
      expect(request.character_names).to eq('')
    end
  end

  context '#character_count' do
    it 'キャラクター数を返す' do
      create_list(:request_to_character, 4, request: request)
      expect(request.character_count).to eq(4)
    end

    it 'キャラクターがない場合は0' do
      expect(request.character_count).to eq(0)
    end
  end
end
