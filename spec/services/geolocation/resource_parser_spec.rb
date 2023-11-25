# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Geolocation::ResourceParser do
  subject { Geolocation::ResourceParser }

  describe "#call" do
    it "returns valid data for correct ip address" do
      expect(subject.call('31.64.163.50')).to eq([:ip, '31.64.163.50'])
    end

    it "returns error data for incorrect ip address" do
      expect(subject.call('31.64.16350')).to eq([:error, nil])
    end

    it "returns valid data for correct domain address" do
      expect(subject.call('google.com')).to eq([:domain, 'google.com'])
    end

    it "returns valid data for correct domain address with http protocol" do
      expect(subject.call('http://www.amazon.com')).to eq([:domain, 'amazon.com'])
    end

    it "returns error data for incorrect domain address" do
      expect(subject.call('simpletext')).to eq([:error, nil])
    end
  end
end
