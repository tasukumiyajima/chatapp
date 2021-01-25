require 'rails_helper'

RSpec.describe Check, type: :model do
  describe "validation" do
    let(:check) { build(:check) }

    it "is not be valid without user_id" do
      check.user_id = nil
      expect(check).to be_invalid
    end

    it "is not be valid without message_id" do
      check.message_id = nil
      expect(check).to be_invalid
    end
  end
end
