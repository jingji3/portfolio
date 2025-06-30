require 'rails_helper'

RSpec.describe Character, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      character = build(:character)
      expect(character).to be_valid
    end
  end

  context 'バリデーション' do
    context 'キャラ名が存在しない場合' do
      it '無効であること' do
        character = build(:character, name: nil)
        expect(character).to be_invalid
        expect(character.errors[:name]).to include('を入力してください')
      end
    end

    context 'キャラ名(かな)が存在しない場合' do
      it '無効であること' do
        character = build(:character, name_kana: nil)
        expect(character).to be_invalid
        expect(character.errors[:name_kana]).to include('を入力してください')
      end
    end

    context 'キャラ名(英語)が存在しない場合' do
      it '無効であること' do
        character = build(:character, name_eng: nil)
        expect(character).to be_invalid
        expect(character.errors[:name_eng]).to include('を入力してください')
      end
    end

    context 'キャラ名が256文字以上の場合' do
      it '無効であること' do
        character = build(:character, name: 'a' * 256)
        expect(character).to be_invalid
        expect(character.errors[:name]).to include('は255文字以内で入力してください')
      end
    end

    context 'キャラ名(かな)が256文字以上の場合' do
      it '無効であること' do
        character = build(:character, name_kana: 'a' * 256)
        expect(character).to be_invalid
        expect(character.errors[:name_kana]).to include('は255文字以内で入力してください')
      end
    end

    context 'キャラ名(英語)が256文字以上の場合' do
      it '無効であること' do
        character = build(:character, name_eng: 'a' * 256)
        expect(character).to be_invalid
        expect(character.errors[:name_eng]).to include('は255文字以内で入力してください')
      end
    end
  end

  context 'enum' do
    it 'elementが正しく動作する' do
      character = build(:character, element: :Pyro)
      expect(character.element).to eq('Pyro')
      expect(character.Pyro?).to be_truthy
    end

    it 'version_halfが正しく動作する' do
      character = build(:character, version_half: :First)
      expect(character.version_half).to eq('First')
      expect(character.First?).to be_truthy
    end
  end

  context 'Active Storage' do
    it 'character_imgが添付できる' do
      character = create(:character)
      expect(character.character_img).to be_an_instance_of(ActiveStorage::Attached::One)
    end
  end

  context 'display_imageメソッド' do
    let(:character) { create(:character) }

    context '画像が添付されていない場合' do
      it 'nilを返す' do
        expect(character.display_image).to be_nil
      end
    end
  end

  context 'Ransack設定' do
    it 'ransackable_attributesが正しく設定されている' do
      expected_attributes = %w[element name name_eng name_kana star version version_half]
      expect(described_class.ransackable_attributes).to match_array(expected_attributes)
    end

    it 'ransackable_associationsが空配列である' do
      expect(described_class.ransackable_associations).to eq([])
    end
  end
end
