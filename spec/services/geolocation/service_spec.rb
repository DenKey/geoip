# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Geolocation::Service do
  subject { Geolocation::Service.new }

  let(:domain) { 'google.com' }
  let(:fakestring) { 'fakestring'}

  describe "#add" do
    it "creates ip_address and domain records for valid domain address" do
      VCR.use_cassette("google") do
        expect {
          subject.add(domain)
        }.to change(IpAddress, :count).and change(Domain, :count)
      end
    end

    it 'returns error object when valid address missed' do
      VCR.use_cassette("fakestring") do
        expect(subject.add(fakestring))
          .to have_key(:errors)
      end
    end
  end

  describe "#find_model" do
    let!(:domain_record) { create(:domain, name: domain) }

    it "returns domain record for valid domain address" do
      VCR.use_cassette("google") do
        expect(subject.find_model(domain)).to be_kind_of(Domain)
      end
    end

    it 'returns error object when valid address missed' do
      VCR.use_cassette("fakestring") do
        expect(subject.find_model(fakestring))
          .to have_key(:errors)
      end
    end
  end

  describe "#lookup" do
    let!(:domain_record) { create(:domain, name: domain) }
    let!(:ip_record) { create(:ip_address, domains: [domain_record]) }

    it "returns ip_addresss domain address" do
      VCR.use_cassette("google") do
        expect(subject.lookup(domain))
          .to match_array([have_attributes(class: IpAddress)])
      end
    end

    it 'returns error object when valid address missed' do
      VCR.use_cassette("fakestring") do
        expect(subject.lookup(fakestring))
          .to have_key(:errors)
      end
    end
  end
end
