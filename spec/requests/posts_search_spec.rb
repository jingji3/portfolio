require 'rails_helper'

RSpec.describe "Posts検索機能", type: :request do
  let!(:char_a) { create(:character, name: "キャラA") }
  let!(:char_b) { create(:character, name: "キャラB") }
  let!(:char_c) { create(:character, name: "キャラC") }

  let!(:user) { create(:user) }

  # キャラA+Bの投稿
  let!(:post_ab) { create(:post, user: user, title: "AB編成") }

  # キャラA+Cの投稿
  let!(:post_ac) { create(:post, user: user, title: "AC編成") }

  # キャラAのみの投稿
  let!(:post_a) { create(:post, user: user, title: "A単体") }

  before do
    # キャラクター関連付けを作成
    create(:posts_to_character, post: post_ab, character: char_a)
    create(:posts_to_character, post: post_ab, character: char_b)

    create(:posts_to_character, post: post_ac, character: char_a)
    create(:posts_to_character, post: post_ac, character: char_c)

    create(:posts_to_character, post: post_a, character: char_a)
  end

  describe "GET /posts キャラクター検索" do
    context "キャラクター1つで検索" do
      it "キャラAを含む投稿がすべて表示される" do
        get posts_path, params: { character1: char_a.id }

        expect(response).to have_http_status(:success)
        expect(response.body).to include(char_a.name)
        # 3つの投稿すべてにキャラAが含まれる
        expect(response.body.scan(post_ab.title).length).to eq(1)
        expect(response.body.scan(post_ac.title).length).to eq(1)
        expect(response.body.scan(post_a.title).length).to eq(1)
      end

      it "キャラBを含む投稿のみ表示される" do
        get posts_path, params: { character1: char_b.id }

        expect(response).to have_http_status(:success)
        expect(response.body).to include(char_b.name)
        # AB編成のみ表示される
        expect(response.body).to include(post_ab.title)
        expect(response.body).not_to include(post_ac.title)
        expect(response.body).not_to include(post_a.title)
      end
    end

    context "複数キャラクターで検索（AND検索）" do
      it "キャラA+Bの投稿のみ表示される" do
        get posts_path, params: {
          character1: char_a.id,
          character2: char_b.id
        }

        expect(response).to have_http_status(:success)
        expect(response.body).to include(char_a.name)
        expect(response.body).to include(char_b.name)
        # AB編成のみ表示される
        expect(response.body).to include(post_ab.title)
        expect(response.body).not_to include(post_ac.title)
        expect(response.body).not_to include(post_a.title)
      end

      it "存在しない組み合わせでは投稿が表示されない" do
        get posts_path, params: {
          character1: char_b.id,
          character2: char_c.id
        }

        expect(response).to have_http_status(:success)
        # B+Cの組み合わせは存在しないので、どの投稿も表示されない
        expect(response.body).not_to include(post_ab.title)
        expect(response.body).not_to include(post_ac.title)
        expect(response.body).not_to include(post_a.title)
      end
    end

    context "パラメータなしの場合" do
      it "全ての投稿が表示される" do
        get posts_path

        expect(response).to have_http_status(:success)
        expect(response.body).to include(post_ab.title)
        expect(response.body).to include(post_ac.title)
        expect(response.body).to include(post_a.title)
      end
    end

    context "空のパラメータの場合" do
      it "全ての投稿が表示される" do
        get posts_path, params: { character1: "" }

        expect(response).to have_http_status(:success)
        expect(response.body).to include(post_ab.title)
        expect(response.body).to include(post_ac.title)
        expect(response.body).to include(post_a.title)
      end
    end
  end
end
