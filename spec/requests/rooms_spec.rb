require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  subject { response.body }

  let(:user) { create(:user) }
  let!(:room1) { create(:room, name: "testroom1") }
  let!(:room2) { create(:room, name: "testroom2") }
  let!(:message_user1_room1) do
    create(
      :message,
      user_id: user.id,
      room_id: room1.id,
      content: "testmessage1"
    )
  end
  let!(:message_user1_room2) do
    create(
      :message,
      user_id: user.id,
      room_id: room2.id,
      content: "testmessage2"
    )
  end

  before do
    sign_in user
  end

  describe "GET /index" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status 200
    end

    it "shows correct instance variable" do
      get root_path
      is_expected.to include "testroom1"
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get new_room_path
      expect(response).to have_http_status 200
    end
  end

  describe "GET /new with ajax" do
    it "returns http success" do
      get new_room_path, xhr: true
      expect(response).to have_http_status 200
    end
  end

  describe "POST /create" do
    it "returns http success" do
      post rooms_path, params: { room: { name: "testroom" } }
      expect(response).to have_http_status 302
      expect(response).to redirect_to root_url
    end
  end

  describe "POST /create with ajax" do
    it "returns http success" do
      post rooms_path, params: { room: { name: "testroom" } }, xhr: true
      expect(response).to have_http_status 200
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get room_path(id: room1.id)
      expect(response).to have_http_status 200
    end

    it "shows correct instance variable" do
      get room_path(id: room1.id)
      is_expected.to include "testroom1"
      is_expected.to include "testmessage1"
    end
  end

  describe "GET /update_check with ajax" do
    it "returns http success" do
      get update_check_path(id: room1.id), xhr: true
      expect(response).to have_http_status 200
    end
  end

  describe "GET /show_additonally with ajax" do
    it "returns http success" do
      get show_additionally_path(id: room1.id), xhr: true
      expect(response).to have_http_status 200
    end
  end

  describe "GET /search" do
    context "when params[:id] is blank" do
      before do
        get search_path, params: { room: { search: "test", id: nil } }
      end

      it "returns http success" do
        expect(response).to have_http_status 200
      end

      it "shows correct instance variable" do
        is_expected.to include "全てのチャットルーム"
        is_expected.to include "test"
        is_expected.to include "testmessage1"
        is_expected.to include "testmessage2"
      end
    end

    context "when params[:id] is correct" do
      context "when params[:search] is blank" do
        before do
          get search_path, params: { room: { search: nil, id: room1.id } }
        end

        it "returns http success" do
          expect(response).to have_http_status 200
        end

        it "shows correct instance variable" do
          is_expected.to include "testroom1"
          is_expected.to include "検索ワードが入力されていません"
          is_expected.not_to include "testmessage1"
          is_expected.not_to include "testmessage2"
        end
      end

      context "when params[:search] can find words" do
        before do
          get search_path, params: { room: { search: "test", id: room1.id } }
        end

        it "returns http success" do
          expect(response).to have_http_status 200
        end

        it "shows correct instance variable" do
          is_expected.to include "testroom1"
          is_expected.to include "test"
          is_expected.to include "testmessage1"
          is_expected.not_to include "testmessage2"
        end
      end

      context "when params[:search] cannot find words" do
        before do
          get search_path, params: { room: { search: "helloworld", id: room1.id } }
        end

        it "returns http success" do
          expect(response).to have_http_status 200
        end

        it "shows correct instance variable" do
          is_expected.to include "testroom1"
          is_expected.to include "helloworld"
          is_expected.not_to include "testmessage1"
          is_expected.not_to include "testmessage2"
        end
      end
    end
  end

  describe "GET /search with ajax" do
    context "when params[:id] is blank" do
      before do
        get search_path, params: { room: { search: "test", id: nil } }, xhr: true
      end

      it "returns http success" do
        expect(response).to have_http_status 200
      end

      it "shows correct instance variable" do
        is_expected.to include "全てのチャットルーム"
        is_expected.to include "test"
        is_expected.to include "testmessage1"
        is_expected.to include "testmessage2"
      end
    end

    context "when params[:id] is correct" do
      context "when params[:search] is blank" do
        before do
          get search_path, params: { room: { search: nil, id: room1.id } }, xhr: true
        end

        it "returns http success" do
          expect(response).to have_http_status 200
        end

        it "shows correct instance variable" do
          is_expected.to include "testroom1"
          is_expected.to include "検索ワードが入力されていません"
          is_expected.not_to include "testmessage1"
          is_expected.not_to include "testmessage2"
        end
      end

      context "when params[:search] can find words" do
        before do
          get search_path, params: { room: { search: "test", id: room1.id } }, xhr: true
        end

        it "returns http success" do
          expect(response).to have_http_status 200
        end

        it "shows correct instance variable" do
          is_expected.to include "testroom1"
          is_expected.to include "test"
          is_expected.to include "testmessage1"
          is_expected.not_to include "testmessage2"
        end
      end

      context "when params[:search] cannot find words" do
        before do
          get search_path, params: { room: { search: "helloworld", id: room1.id } }, xhr: true
        end

        it "returns http success" do
          expect(response).to have_http_status 200
        end

        it "shows correct instance variable" do
          is_expected.to include "testroom1"
          is_expected.to include "helloworld"
          is_expected.not_to include "testmessage1"
          is_expected.not_to include "testmessage2"
        end
      end
    end
  end
end
