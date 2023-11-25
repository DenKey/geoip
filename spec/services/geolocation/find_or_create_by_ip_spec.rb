# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Geolocation::FindOrCreateByIp do
  subject { Geolocation::FindOrCreateByIp }

  let(:provider) { Ipstack::Service.new }
  let(:ip) { '172.253.63.100' }
  let(:fakestring) { 'fakestring'}

  describe "#call" do
    it "creates ip_address record for valid ip address" do
      VCR.use_cassette("google_ip") do
        expect {
          subject.new(provider).call(ip)
        }.to change(IpAddress, :count)
      end
    end

    it 'returns ip_addresses list' do
      VCR.use_cassette("google_ip") do
        expect(subject.new(provider).call(ip))
          .to match_array([have_attributes(class: IpAddress)])
      end
    end

    it 'returns error object when valid ip missed' do
      VCR.use_cassette("fakestring") do
        expect(subject.new(provider).call(fakestring))
          .to have_key(:errors)
      end
    end

    describe 'when domain ip already exists' do
      let(:address) { '172.253.63.100' }
      let(:domain) { 'google.com' }
      let(:ipaddr) { IPAddr.new(address) }
      let!(:domain_record) { create(:domain, name: domain) }
      let!(:ip_record) { create(:ip_address, address: address, domains: [domain_record]) }

      it 'returns ip_addresses list' do
        VCR.use_cassette("google_ip") do
          expect(subject.new(provider).call(address))
            .to match_array([have_attributes(class: IpAddress, address: ipaddr)])
        end
      end
    end
  end
end
