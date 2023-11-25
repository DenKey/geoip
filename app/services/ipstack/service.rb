# frozen_string_literal: true

module Ipstack
  class Service
    API_KEY = ENV['IPSTACK_API_KEY'].freeze
    BASE_URL = 'http://api.ipstack.com/'.freeze

    def initialize
      @client = HttpClient.new(base_url: BASE_URL)
    end

    # Accept string with IP address or domain
    def call(resource)
      @client.get("#{resource}", default_params)
    end

    private

    def default_params
      {
        access_key: API_KEY
      }
    end
  end
end
