# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Geolocation::FindOrCreateByDomain do
  subject { Geolocation::FindOrCreateByDomain }

  let(:provider) { Ipstack::Service.new }
  let(:domain) { 'google.com' }
  let(:fakestring) { 'fakestring'}

  describe "#call" do
    it "creates ip_address and domain records for valid address" do
      VCR.use_cassette("google") do
        expect {
          subject.new(provider).call(domain)
        }.to change(IpAddress, :count).and change(Domain, :count)
      end
    end

    it 'returns ip_addresses list' do
      VCR.use_cassette("google") do
        expect(subject.new(provider).call(domain))
          .to match_array([have_attributes(class: IpAddress)])
      end
    end

    it 'returns error object when valid address missed' do
      VCR.use_cassette("fakestring") do
        expect(subject.new(provider).call(fakestring))
          .to have_key(:errors)
      end
    end

    describe 'when domain already exists' do
      let(:address) { '1.1.1.1' }
      let(:ipaddr) { IPAddr.new(address) }
      let!(:domain_record) { create(:domain, name: domain) }
      let!(:ip_record) { create(:ip_address, address: address, domains: [domain_record]) }

      it 'returns ip_addresses list' do
        VCR.use_cassette("google") do
          expect(subject.new(provider).call(domain))
            .to match_array([have_attributes(class: IpAddress, address: ipaddr)])
        end
      end
    end
  end
end
