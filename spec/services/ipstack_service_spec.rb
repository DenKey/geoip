# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ipstack::Service do
  subject { Ipstack::Service.new }

  describe "#check" do
    it 'returns valid geodata for google.com' do
      VCR.use_cassette("google") do
        result = subject.call('google.com')
        expect(result[:latitude]).to eq(37.419158935546875)
        expect(result[:longitude]).to eq(-122.07540893554688)
      end
    end

    it 'returns error message for fakestring' do
      VCR.use_cassette("fakestring") do
        result = subject.call('fakestring')
        expect(result[:success]).to be_falsey
        expect(result[:error][:code]).to eq(106)
        expect(result[:error][:type]).to eq('invalid_ip_address')
      end
    end

    it 'returns nil for internal server error on service side' do
      VCR.use_cassette("internal_server_error") do
        result = subject.call('facebook.com')
        expect(result).to be_nil
      end
    end
  end
end
