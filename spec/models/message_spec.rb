require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "validation" do
    let(:message) { build(:message) }

    it "is not be valid without user_id" do
      message.user_id = nil
      expect(message).to be_invalid
      message.valid?
      expect(message.errors[:user_id]).to include("を入力してください")
    end

    it "is not be valid without content" do
      message.content = nil
      expect(message).to be_invalid
      message.valid?
      expect(message.errors[:content]).to include("を入力してください")
    end

    it "is not be valid with too long content" do
      message.content = "a" * 501
      expect(message).to be_invalid
      message.valid?
      expect(message.errors[:content]).to include("は500文字以内で入力してください")
    end
  end

  describe "checked_users" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:user3) { create(:user) }
    let(:room1) { create(:room) }
    let!(:message_user1_room1) { create(:message, user_id: user1.id, room_id: room1.id) }
    let!(:check_user2_room1) do
      create(
        :check,
        user_id: user2.id,
        message_id: message_user1_room1.id
      )
    end
    let!(:check_user3_room1) do
      create(
        :check,
        user_id: user3.id,
        message_id: message_user1_room1.id
      )
    end

    it "deletes Check only in argument's room" do
      expect(message_user1_room1.checked_users).to eq [user2, user3]
    end
  end

  describe "self.search" do
    let(:user1) { create(:user) }
    let(:room1) { create(:room) }
    let(:room2) { create(:room) }
    let!(:messages_user1_room1) { create_list(:message, 2, user_id: user1.id, room_id: room1.id) }
    let!(:messages_user1_room2) { create_list(:message, 2, user_id: user1.id, room_id: room2.id) }

    context "with argument of room_id" do
      it "return searched messages only in argument's room" do
        expect(Message.search("test", room1.id).length).to eq 2
      end
    end

    context "without argument of room_id" do
      it "return searched messages in all room" do
        expect(Message.search("test", nil).length).to eq 4
      end
    end
  end
end
