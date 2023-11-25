require 'rails_helper'

RSpec.describe "Resources", type: :request do
  describe "POST /api/v1/ip_addresses" do
    it 'returns valid ip_address attributes' do
      VCR.use_cassette("google") do
        # send a POST request to /api, with these parameters
        # The controller will treat them as JSON
        post '/api/v1/ip_addresses', params: {
          data: {
            resource: 'google.com',
          }
        }

        expect(response.status).to eq(200)

        json = JSON.parse(response.body).deep_symbolize_keys

        record = json[:data].first

        expect(record[:type]).to eq('ip_address')
        expect(record[:attributes][:ip_address]).to eq('172.253.63.100')
        expect(record[:attributes][:longitude]).to eq(-122.07540893554688)
        expect(record[:attributes][:latitude]).to eq(37.419158935546875)

        expect(IpAddress.count).to eq(1)
      end
    end

    it 'returns valid errors messages' do
      VCR.use_cassette("fakestring") do
        # send a POST request to /api, with these parameters
        # The controller will treat them as JSON
        post '/api/v1/ip_addresses', params: {
          data: {
            resource: 'fakestring',
          }
        }

        expect(response.status).to eq(200)

        json = JSON.parse(response.body).deep_symbolize_keys
        error = json[:errors].first

        expect(error[:status]).to eq(400)
        expect(error[:title]).to eq("Input format is not valid")
      end
    end
  end

  describe "POST /api/v1/ip_addresses/lookup" do
    let(:address) { '172.253.63.100' }
    let(:domain) { 'google.com' }
    let(:ipaddr) { IPAddr.new(address) }
    let!(:domain_record) { create(:domain, name: domain) }
    let!(:ip_record) { create(:ip_address, address: address, domains: [domain_record]) }

    it 'returns valid ip_address attributes' do
      VCR.use_cassette("google") do
        # send a POST request to /api, with these parameters
        # The controller will treat them as JSON
        post '/api/v1/ip_addresses/lookup', params: {
          data: {
            resource: 'google.com',
          }
        }

        expect(response.status).to eq(200)

        json = JSON.parse(response.body).deep_symbolize_keys

        record = json[:data].first

        expect(record[:type]).to eq('ip_address')
        expect(record[:id]).to eq(ip_record.id)
        expect(record[:attributes][:ip_address]).to eq('172.253.63.100')
      end
    end

    it 'returns valid errors messages' do
      VCR.use_cassette("facebook") do
        # send a POST request to /api, with these parameters
        # The controller will treat them as JSON
        post '/api/v1/ip_addresses/lookup', params: {
          data: {
            resource: 'facebook.com',
          }
        }

        expect(response.status).to eq(200)

        json = JSON.parse(response.body).deep_symbolize_keys
        error = json[:errors].first

        expect(error[:status]).to eq(404)
        expect(error[:title]).to eq("Requested record not found")
      end
    end
  end

  describe "POST /api/v1/ip_addresses/delete" do
    let(:address) { '172.253.63.100' }
    let(:domain) { 'google.com' }
    let(:ipaddr) { IPAddr.new(address) }
    let!(:domain_record) { create(:domain, name: domain) }
    let!(:ip_record) { create(:ip_address, address: address, domains: [domain_record]) }

    it 'returns ok response' do
      VCR.use_cassette("google") do
        # send a POST request to /api, with these parameters
        # The controller will treat them as JSON
        post '/api/v1/ip_addresses/delete', params: {
          data: {
            resource: 'google.com',
          }
        }

        expect(response.status).to eq(200)

        expect(response.body).to eq('ok')
      end
    end

    it 'returns valid errors messages' do
      VCR.use_cassette("facebook") do
        # send a POST request to /api, with these parameters
        # The controller will treat them as JSON
        post '/api/v1/ip_addresses/delete', params: {
          data: {
            resource: 'facebook.com',
          }
        }

        expect(response.status).to eq(200)

        json = JSON.parse(response.body).deep_symbolize_keys
        error = json[:errors].first

        expect(error[:status]).to eq(404)
        expect(error[:title]).to eq("Requested record not found")
      end
    end
  end
end
