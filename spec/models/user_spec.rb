require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validation" do
    let(:user) { build(:user) }

    it "is not be valid without name" do
      user.name = nil
      expect(user).to be_invalid
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end

    it "is not be valid with too long name" do
      user.name = "a" * 51
      expect(user).to be_invalid
      user.valid?
      expect(user.errors[:name]).to include("は50文字以内で入力してください")
    end
  end

  describe "delete_checks_in" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:room1) { create(:room) }
    let(:room2) { create(:room) }
    let!(:message_user1_room1) { create(:message, user_id: user1.id, room_id: room1.id) }
    let!(:message_user1_room2) { create(:message, user_id: user1.id, room_id: room2.id) }
    let!(:message_user2_room1) { create(:message, user_id: user2.id, room_id: room1.id) }
    let!(:message_user2_room2) { create(:message, user_id: user2.id, room_id: room2.id) }
    let!(:check_user1_room1) do
      create(
        :check,
        user_id: user1.id,
        message_id: message_user2_room1.id
      )
    end
    let!(:check_user1_room2) do
      create(
        :check,
        user_id: user1.id,
        message_id: message_user2_room2.id
      )
    end

    it "deletes Check only in argument's room" do
      expect do
        user1.delete_checks_in(room1)
      end.to change(Check, :count).by(-1)
    end
  end
end
