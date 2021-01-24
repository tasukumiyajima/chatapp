require 'rails_helper'

RSpec.describe "Api::Emojis", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
    get api_emojis_path(query: "a")
  end

  describe "GET /index" do
    it "returns http success" do
      expect(response).to have_http_status 200
    end

    it "responds with JSON formatted output" do
      expect(response.content_type).to eq "application/json"
    end

    it "returns 10 keywords" do
      expect(JSON.parse(response.body).length).to eq 10
    end
  end
end
