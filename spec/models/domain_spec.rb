require 'rails_helper'

RSpec.describe Domain, type: :model do
  it { should validate_presence_of(:name) }
  it { should have_and_belong_to_many(:ip_addresses) }

  describe "uniqueness validations" do
    subject { build(:domain) }
    it { should validate_uniqueness_of(:name) }
  end
end
