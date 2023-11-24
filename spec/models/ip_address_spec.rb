require 'rails_helper'

RSpec.describe IpAddress, type: :model do
  [:address, :ip_type, :coordinate].each do |field|
    it { should validate_presence_of(field) }
  end

  it { should have_and_belong_to_many(:domains) }

  describe "uniqueness validations" do
    subject { build(:ip_address) }
    it { should validate_uniqueness_of(:address) }
  end
end
