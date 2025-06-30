require 'rails_helper'

RSpec.describe "Tops", type: :request do
  describe "GET /index" do
    it "正常にページが表示される" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
