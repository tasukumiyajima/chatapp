require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "validation" do
    let(:room) { build(:room) }

    it "is not be valid without name" do
      room.name = nil
      expect(room).to be_invalid
      room.valid?
      expect(room.errors[:name]).to include("を入力してください")
    end

    it "is not be valid with too long name" do
      room.name = "a" * 51
      expect(room).to be_invalid
      room.valid?
      expect(room.errors[:name]).to include("は50文字以内で入力してください")
    end
  end

  describe "users_of_messages" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:room1) { create(:room) }
    let(:room2) { create(:room) }
    let!(:message_user1_room1) { create_list(:message, 5, user_id: user1.id, room_id: room1.id) }
    let!(:message_user1_room2) { create(:message, user_id: user1.id, room_id: room2.id) }
    let!(:message_user2_room1) { create(:message, user_id: user2.id, room_id: room1.id) }

    it "retrun users who have message in the room" do
      expect(room1.users_of_messages).to eq [user1, user2]
      expect(room2.users_of_messages).to eq [user1]
    end
  end
end
