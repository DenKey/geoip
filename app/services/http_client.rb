# frozen_string_literal: true

class HttpClient
  def initialize(options)
    @client = faraday_client(options)
  end

  def get(path, params = {})
    request do
      @client.get do |req|
        req.url(path, params)
      end
    end
  end

  def request
    response = yield

    if response.nil? || response.status != 200
      # TODO: Add corresponding logging call
      nil
    else
      response.body
    end
  end

  def faraday_client(options)
    Faraday.new(url: options[:base_url]) do |faraday|
      faraday.request :json
      faraday.response :json, content_type: /\bjson$/, parser_options: {symbolize_names: true}
      faraday.adapter(Faraday.default_adapter)
    end
  end
end
