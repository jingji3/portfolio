require 'rails_helper'

RSpec.describe "Oauths", type: :request do
  describe "POST /oauth/:provider" do
    it "redirects to OAuth provider" do
      post "/oauth/google"
      expect(response).to have_http_status(:redirect)
    end
  end
end
