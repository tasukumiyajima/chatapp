require 'rails_helper'

RSpec.describe "RoomsShows", type: :system, js: true do
  subject { page }

  let(:user1) { create(:user, name: "user1") }
  let(:user2) { create(:user, name: "user2") }
  let!(:room1) { create(:room, name: "testroom1") }
  let!(:room2) { create(:room, name: "testroom2") }
  let!(:message_user1_room1) { create(:message, user_id: user1.id, room_id: room1.id) }
  let!(:message_user2_room1) { create(:message, user_id: user2.id, room_id: room1.id) }
  let!(:message_user1_room2) { create_list(:message, 15, user_id: user1.id, room_id: room2.id) }

  before do
    sign_in user1
    visit room_path(room1)
  end

  it "shows correct layout" do
    is_expected.to have_current_path room_path(room1)
    is_expected.to have_title "testroom1 | ChatApp"
    is_expected.to have_content "チャットルーム名：testroom1", count: 1
    is_expected.to have_content "testmessage", count: 2
    is_expected.not_to have_content "既読"
    find('.fa-angle-left').click
    is_expected.to have_current_path rooms_path
    visit room_path(room2)
    is_expected.to have_title "testroom2 | ChatApp"
    is_expected.to have_content "チャットルーム名：testroom2", count: 1
    is_expected.to have_content "testmessage", count: 10
  end

  it "shows 既読 when other user create check" do
    user2.checks.create(message_id: message_user1_room1.id)
    visit room_path(room1)
    is_expected.to have_content "既読 /user2", count: 1
  end

  it "makes new message in its room" do
    expect do
      fill_in 'content', with: ''
      click_on '入力'
      fill_in 'content', with: 'new-message'
      click_on '入力'
      is_expected.to have_current_path room_path(room1)
      is_expected.to have_content "new-message", count: 1
    end.to change(Message, :count).by(1)
  end

  it "searches words in its room" do
    fill_in 'room_search', with: ''
    click_on '検索'
    is_expected.to have_content "検索ワード：検索ワードが入力されていません", count: 1
    is_expected.to have_content "検索対象のチャットルーム：testroom1", count: 1
    find('.fa-2x').click
    fill_in 'room_search', with: 'test'
    click_on '検索'
    is_expected.to have_content "検索ワード：test", count: 1
    is_expected.to have_content "検索対象のチャットルーム：testroom1", count: 1
    is_expected.to have_content "testmessage", count: 4 # 検索結果のワード2つ＋検索前のワード2つ
    find('.fa-2x').click
    fill_in 'room_search', with: 'helloworld'
    click_on '検索'
    is_expected.to have_content "検索ワード：helloworld", count: 1
    is_expected.to have_content "検索対象のチャットルーム：testroom1", count: 1
    is_expected.to have_content "testmessage", count: 2 # 検索前のワード2つのみ
  end
end
