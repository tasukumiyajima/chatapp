require 'rails_helper'

RSpec.describe "RoomsIndices", type: :system, js: true do
  subject { page }

  let(:user1) { create(:user, name: "user1") }
  let(:user2) { create(:user, name: "user2") }
  let!(:room1) { create(:room, name: "testroom1") }
  let!(:room2) { create(:room, name: "testroom2") }
  let!(:message_user1_room1) { create(:message, user_id: user1.id, room_id: room1.id) }
  let!(:message_user2_room1) { create(:message, user_id: user2.id, room_id: room1.id) }
  let!(:message_user2_room2) { create(:message, user_id: user2.id, room_id: room2.id) }

  before do
    sign_in user1
    visit root_path
  end

  it "shows correct layout" do
    is_expected.to have_current_path root_path
    is_expected.to have_title "ChatApp"
    is_expected.to have_link "マイアカウント", count: 1
    is_expected.to have_content "チャットルーム一覧", count: 1
    is_expected.to have_link "testroom1", href: room_path(room1)
    is_expected.to have_content "このチャットルームの参加者 /user1 /user2", count: 1
    is_expected.to have_link "testroom2", href: room_path(room2)
    is_expected.to have_content "このチャットルームの参加者 /user2", count: 1
    click_link "testroom1"
    expect(current_path).to eq room_path(room1)
  end

  it "makes new chat room" do
    is_expected.not_to have_link "new-testroom"
    is_expected.to have_link "チャットルームを作成する", count: 1
    expect do
      click_on "チャットルームを作成する"
      is_expected.to have_current_path root_path
      fill_in 'room_name', with: ''
      click_on 'チャットルームの作成'
      is_expected.to have_selector(".alert-danger", text: "エラーが1個あります")
      fill_in 'room_name', with: 'new-testroom'
      click_on 'チャットルームの作成'
      is_expected.to have_current_path root_path
      is_expected.to have_link "new-testroom"
    end.to change(Room, :count).by(1)
  end

  it "search words in all rooms" do
    fill_in 'room_search', with: ''
    click_on '検索'
    is_expected.to have_content "検索ワード：検索ワードが入力されていません", count: 1
    is_expected.to have_content "検索対象のチャットルーム：全てのチャットルーム", count: 1
    find('.fa-2x').click
    fill_in 'room_search', with: 'test'
    click_on '検索'
    is_expected.to have_content "検索ワード：test", count: 1
    is_expected.to have_content "検索対象のチャットルーム：全てのチャットルーム", count: 1
    is_expected.to have_content "testmessage", count: 3
    find('.fa-2x').click
    fill_in 'room_search', with: 'helloworld'
    click_on '検索'
    is_expected.to have_content "検索ワード：helloworld", count: 1
    is_expected.to have_content "検索対象のチャットルーム：全てのチャットルーム", count: 1
    is_expected.not_to have_content "testmessage"
  end
end
