require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "validation" do
    context "without name" do
      it "is not be valid" do
        user.name = nil
        expect(user).to be_invalid
      end
    end

    context "with too long name" do
      it "is not be valid" do
        user.name = "a" * 51
        expect(user).to be_invalid
      end
    end
  end
end
